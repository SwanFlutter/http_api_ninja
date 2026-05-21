import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/collection_model.dart';
import '../models/http_request_model.dart';

class ImportUtils {
  static dynamic parseImport(String type, String input) {
    if (input.trim().isEmpty) return _emptyCollection("Empty Input");

    if (type.toLowerCase() == 'json') {
      return _parseJsonSmart(input);
    }

    switch (type.toLowerCase()) {
      case 'curl':
        return _parseCurl(input);
      case 'url':
        return _parseUrl(input);
      case 'raw':
      case 'text':
        return _parseRaw(input);
      case 'grpcurl':
        return _parseGrpc(input);
      default:
        return _emptyCollection("Unknown Type");
    }
  }

  // ======================= SMART JSON PARSER =======================
  static dynamic _parseJsonSmart(String input) {
    // Attempt 1: parse as-is
    try {
      return _doParseJson(input);
    } catch (_) {}

    // Attempt 2: light cleanup (BOM, trailing commas)
    try {
      return _doParseJson(_lightFixJson(input));
    } catch (_) {}

    // Attempt 3: strip the "response" arrays — they often contain unescaped
    // quotes in body/description fields and are not needed for importing
    // requests.  This is safe because we never use response data.
    if (input.length <= 5000000) {
      try {
        final stripped = _stripResponseArrays(input);
        return _doParseJson(stripped);
      } catch (_) {}

      // Attempt 4: strip responses + light fix
      try {
        final stripped = _lightFixJson(_stripResponseArrays(input));
        return _doParseJson(stripped);
      } catch (_) {}
    }

    // Attempt 5: full character-level repair (only for smaller inputs)
    if (input.length <= 500000) {
      try {
        return _doParseJson(_repairJson(input));
      } catch (e) {
        debugPrint("Repair failed: $e");
      }
    }

    return _emptyCollection("Invalid JSON");
  }

  /// Removes `"response": [...]` arrays from a Postman JSON string using a
  /// simple bracket-depth scanner.  This avoids regex catastrophic
  /// backtracking on large files and sidesteps unescaped-quote issues that
  /// only appear inside response bodies.
  static String _stripResponseArrays(String src) {
    // We look for the literal token  "response":  followed by  [
    // then skip everything until the matching ] (respecting nesting).
    final buf = StringBuffer();
    int i = 0;
    while (i < src.length) {
      // Try to match  "response"\s*:\s*[
      if (src[i] == '"' && src.startsWith('"response"', i)) {
        final keyEnd = i + 10; // length of '"response"' = 10
        // skip whitespace + colon + whitespace
        int j = keyEnd;
        while (j < src.length &&
            (src[j] == ' ' ||
                src[j] == '\t' ||
                src[j] == '\n' ||
                src[j] == '\r')) {
          j++;
        }
        if (j < src.length && src[j] == ':') {
          j++;
          while (j < src.length &&
              (src[j] == ' ' ||
                  src[j] == '\t' ||
                  src[j] == '\n' ||
                  src[j] == '\r')) {
            j++;
          }
          if (j < src.length && src[j] == '[') {
            // Found "response": [ — skip to matching ]
            int depth = 1;
            j++;
            bool inStr = false;
            while (j < src.length && depth > 0) {
              final c = src[j];
              if (inStr) {
                if (c == '\\') {
                  j += 2;
                  continue;
                }
                if (c == '"') inStr = false;
              } else {
                if (c == '"')
                  inStr = true;
                else if (c == '[')
                  depth++;
                else if (c == ']')
                  depth--;
              }
              j++;
            }
            // Replace with empty array to keep JSON valid
            buf.write('"response": []');
            i = j;
            continue;
          }
        }
      }
      buf.write(src[i]);
      i++;
    }
    return buf.toString();
  }

  /// Quick, allocation-light fixes that are safe on large strings.
  static String _lightFixJson(String input) {
    // Remove BOM if present
    String out = input.trimLeft();
    if (out.startsWith('\uFEFF')) out = out.substring(1);

    // Remove trailing commas before } or ]
    out = out.replaceAll(RegExp(r',\s*}'), '}');
    out = out.replaceAll(RegExp(r',\s*]'), ']');

    return out;
  }

  static dynamic _doParseJson(String input) {
    var data = jsonDecode(input);

    // Handle nested 'collection' key (common in some Postman exports)
    if (data is Map<String, dynamic> && data.containsKey("collection")) {
      data = data["collection"];
    }

    if (data is Map<String, dynamic>) {
      if (data.containsKey("info") || data.containsKey("item")) {
        debugPrint("Detected Postman format...");
        return _normalizePostman(data);
      }

      if (data.containsKey("requests") && data.containsKey("name")) {
        debugPrint("Detected App Collection format...");
        return CollectionModel.fromJson(data);
      }

      if (data.containsKey("method") && data.containsKey("url")) {
        debugPrint("Detected Single Request format...");
        return HttpRequestModel.fromJson(data);
      }
    }

    debugPrint("JSON structure not recognized.");
    return _emptyCollection("Unsupported JSON structure");
  }

  // ======================= REPAIR ENGINE =======================
  // Only called for inputs <= 500 KB to prevent catastrophic backtracking
  // on huge strings with complex regex patterns.
  static String _repairJson(String input) {
    if (input.length > 2000000) return input;

    // Step 1: remove illegal control characters (keep \t \n \r)
    String out = input.trim().replaceAll(
      RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'),
      '',
    );

    // Step 2: fix unescaped double-quotes inside JSON string values.
    //
    // The problem pattern (from Postman/Laravel API doc exports):
    //   "body": "{"success":false,"message":"..."}"
    // The inner quotes are not escaped, making the JSON invalid.
    //
    // We walk the string character-by-character so we can distinguish
    // "we are inside a JSON string value" from "we are at a structural
    // character".  When inside a string value we escape any bare " that
    // is not already preceded by \.
    out = _fixUnescapedQuotesInValues(out);

    // Step 3: remove trailing commas
    out = out.replaceAll(RegExp(r',\s*}'), '}');
    out = out.replaceAll(RegExp(r',\s*]'), ']');

    return out;
  }

  /// Walks [src] character-by-character and escapes any double-quote that
  /// appears inside a JSON string value but is not already backslash-escaped.
  ///
  /// Algorithm:
  ///   We track whether we are inside a string or outside.
  ///   Outside: structural chars ( { } [ ] : , ) and opening quotes.
  ///   Inside a KEY string: copy verbatim until unescaped closing quote.
  ///   Inside a VALUE string: when we see an unescaped quote, we must decide
  ///     if it is the *real* closing quote or a bare quote inside the value.
  ///
  ///   Decision rule for a quote inside a value:
  ///     Scan forward from the candidate closing quote.  Try to parse the
  ///     remainder as valid JSON structure (key or structural char).
  ///     If the very next non-whitespace char is  ,  }  ]  we treat it as
  ///     the real closing quote.
  ///     Otherwise we escape it and keep reading.
  static String _fixUnescapedQuotesInValues(String src) {
    final buf = StringBuffer();
    const int stOutside = 0;
    const int stInKey = 1;
    const int stAfterKey = 2;
    const int stInValue = 3;

    int state = stOutside;
    bool expectValue = false;

    int i = 0;
    while (i < src.length) {
      final ch = src[i];

      switch (state) {
        case stOutside:
          if (ch == '"') {
            buf.write(ch);
            if (expectValue) {
              state = stInValue;
              expectValue = false;
            } else {
              state = stInKey;
            }
          } else {
            buf.write(ch);
            if (ch == ':') {
              expectValue = true;
            } else if (ch == ',' ||
                ch == '{' ||
                ch == '[' ||
                ch == '}' ||
                ch == ']') {
              expectValue = false;
            }
          }

        case stInKey:
          if (ch == '\\' && i + 1 < src.length) {
            buf.write(ch);
            buf.write(src[i + 1]);
            i += 2;
            continue;
          }
          if (ch == '"') {
            buf.write(ch);
            state = stAfterKey;
          } else {
            buf.write(ch);
          }

        case stAfterKey:
          buf.write(ch);
          if (ch == ':') {
            expectValue = true;
            state = stOutside;
          } else if (ch != ' ' && ch != '\t' && ch != '\n' && ch != '\r') {
            state = stOutside;
          }

        case stInValue:
          if (ch == '\\' && i + 1 < src.length) {
            buf.write(ch);
            buf.write(src[i + 1]);
            i += 2;
            continue;
          }
          if (ch == '"') {
            // Only treat as closing quote if the very next non-whitespace
            // char is a JSON structural separator: ,  }  ]
            // A following " (next key) is NOT sufficient — it could be a
            // quoted word inside the value like "working_days".
            if (_isStructuralNext(src, i + 1)) {
              buf.write(ch); // real closing quote
              state = stOutside;
              expectValue = false;
            } else {
              buf.write('\\"'); // bare quote inside value → escape
            }
          } else {
            buf.write(ch);
          }
      }
      i++;
    }
    return buf.toString();
  }

  /// Returns true only when the next non-whitespace character after position
  /// [pos] is a JSON value-terminating character: ,  }  ]  or end-of-input.
  ///
  /// A following `"` is intentionally NOT considered terminating because it
  /// could be a quoted word inside a description string.
  static bool _isStructuralNext(String src, int pos) {
    int j = pos;
    while (j < src.length) {
      final c = src[j];
      if (c == ' ' || c == '\t' || c == '\n' || c == '\r') {
        j++;
        continue;
      }
      return c == ',' || c == '}' || c == ']';
    }
    return true; // end of input
  }

  // ======================= NORMALIZER =======================
  static dynamic _normalizePostman(Map<String, dynamic> data) {
    final info = data["info"] ?? {};
    final rootName = info["name"] ?? "Imported Collection";
    final items = data["item"];

    debugPrint("Normalizing Postman collection: $rootName");

    if (items is! List) {
      return _emptyCollection(rootName);
    }

    // Recursively parse Postman items into requests and folders
    CollectionModel parseLevel(String name, List itemsList, [String idPrefix = ""]) {
      final List<HttpRequestModel> requests = [];
      final List<CollectionModel> subFolders = [];

      for (var i = 0; i < itemsList.length; i++) {
        final item = itemsList[i];
        if (item is Map<String, dynamic>) {
          final itemName = item["name"]?.toString() ?? "Unnamed";
          final String currentId = idPrefix.isEmpty ? "$i" : "${idPrefix}_$i";

          if (item.containsKey("request")) {
            // It's a request
            requests.add(_convertPostmanRequest(item, requests.length));
          } else if (item.containsKey("item")) {
            // It's a folder
            subFolders.add(parseLevel(
              itemName,
              item["item"] as List,
              "${currentId}_f",
            ));
          }
        }
      }

      return CollectionModel(
        id: "${DateTime.now().millisecondsSinceEpoch}_$idPrefix",
        name: name,
        requests: requests,
        folders: subFolders,
        isExpanded: false, // Start collapsed for nested folders
      );
    }

    final rootCollection = parseLevel(rootName, items);
    
    // Some users prefer many top-level collections if the Postman file is a set of collections
    // But here we return a single root collection containing everything as requested.
    return rootCollection;
  }

  static HttpRequestModel _convertPostmanRequest(
    Map<String, dynamic> item,
    int index,
  ) {
    final req = item["request"] ?? {};
    final String name = item["name"]?.toString() ?? "Request";
    final String method = req["method"]?.toString() ?? "GET";
    String url = "";
    final Map<String, String> headers = {};
    String body = "";

    final urlData = req["url"];
    if (urlData is String) {
      url = urlData;
    } else if (urlData is Map<String, dynamic>) {
      url = urlData["raw"]?.toString() ?? "";
    }

    final headerList = req["header"];
    if (headerList is List) {
      for (var h in headerList) {
        if (h is Map<String, dynamic>) {
          final key = h["key"]?.toString() ?? "";
          final val = h["value"]?.toString() ?? "";
          if (key.isNotEmpty) headers[key] = val;
        }
      }
    }

    final bodyData = req["body"];
    if (bodyData is Map<String, dynamic>) {
      final mode = bodyData["mode"];
      if (mode == "raw") {
        body = bodyData["raw"]?.toString() ?? "";
      } else if (mode == "formdata") {
        final List? fd = bodyData["formdata"];
        if (fd != null) {
          body = fd
              .whereType<Map>()
              .map((e) => "${e['key']}: ${e['value']}")
              .join("\n");
        }
      }
    }

    return HttpRequestModel(
      id: "${DateTime.now().millisecondsSinceEpoch}_$index",
      name: name,
      method: method,
      url: url,
      headers: headers,
      body: body,
      createdAt: DateTime.now(),
    );
  }

  // ======================= PARSERS =======================
  static HttpRequestModel _parseCurl(String input) {
    String method = "GET";
    String url = "";
    final Map<String, String> headers = {};
    String body = "";

    // METHOD
    final methodMatch = RegExp(
      r'(?:-X|--request)\s+([A-Z]+)',
    ).firstMatch(input);
    if (methodMatch != null) {
      method = methodMatch.group(1)!;
    }

    // HEADERS — limit match length to avoid backtracking on huge inputs
    final headerMatches = RegExp(
      r'''(?:-H|--header)\s+['"]([^'"]{1,2000})['"]''',
    ).allMatches(input);

    for (var m in headerMatches) {
      final header = m.group(1) ?? "";
      final colonIdx = header.indexOf(':');
      if (colonIdx > 0) {
        headers[header.substring(0, colonIdx).trim()] = header
            .substring(colonIdx + 1)
            .trim();
      }
    }

    // BODY — limit to 10 MB to prevent memory issues
    final dataMatch = RegExp(
      r'''(?:-d|--data|--data-raw|--data-binary)\s+['"]([^'"]{0,10485760})['"]''',
    ).firstMatch(input);

    if (dataMatch != null) {
      body = dataMatch.group(1)!;
      if (method == "GET") method = "POST";
    }

    // URL
    final urlMatch = RegExp(
      r'''['"]?(https?://[^\s'"]{1,2000})['"]?''',
    ).firstMatch(input);
    if (urlMatch != null) {
      url = urlMatch.group(1) ?? "";
    }

    return HttpRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: "Imported curl",
      method: method,
      url: url,
      headers: headers,
      body: body,
      createdAt: DateTime.now(),
    );
  }

  static HttpRequestModel _parseUrl(String input) {
    return HttpRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: "Imported URL",
      method: "GET",
      url: input.trim(),
      createdAt: DateTime.now(),
    );
  }

  static HttpRequestModel _parseRaw(String input) {
    return HttpRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: "Imported Raw",
      method: "POST",
      url: "",
      body: input.trim(),
      createdAt: DateTime.now(),
    );
  }

  static HttpRequestModel _parseGrpc(String input) {
    return HttpRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: "Imported gRPC",
      method: "POST",
      url: "",
      body: input.trim(),
      createdAt: DateTime.now(),
    );
  }

  static CollectionModel _emptyCollection(String name) {
    return CollectionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      requests: [],
    );
  }
}
