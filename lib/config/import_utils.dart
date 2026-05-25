// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../controller/environment_mixin.dart';
import '../models/collection_model.dart';
import '../models/http_request_model.dart';

class ImportUtils {
  // ======================= PUBLIC ENTRY =======================

  static dynamic parseImport(String type, String input) {
    if (input.trim().isEmpty) return _emptyCollection("Empty Input");
    if (type.toLowerCase() == 'json') return _parseJsonSmart(input);
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
    // 1. as-is
    try {
      return _doParseJson(input);
    } catch (_) {}

    // 2. light fix (BOM, trailing commas)
    try {
      return _doParseJson(_lightFixJson(input));
    } catch (_) {}

    // 3. Robust character-level repair (Try to fix unescaped quotes in values)
    // Most effective for Postman exports with unescaped JSON in "raw" or "body"
    if (input.length <= 5000000) {
      try {
        return _doParseJson(_repairJson(input));
      } catch (e3) {
        debugPrint("Attempt 3 (Repair) failed: $e3");
      }
    }

    if (input.length <= 5000000) {
      // 4. strip "response" arrays first (common source of heavy/broken JSON)
      try {
        return _doParseJson(_stripResponseArrays(input));
      } catch (_) {}

      if (input.length <= 5000000) {
        // 5. strip raw field
        try {
          return _doParseJson(_stripStringField(input, 'raw'));
        } catch (_) {}

        // 6. strip raw + body
        try {
          var s = _stripStringField(input, 'raw');
          s = _stripStringField(s, 'body');
          return _doParseJson(s);
        } catch (_) {}

        // 7. strip raw + body + description
        try {
          var s = _stripStringField(input, 'raw');
          s = _stripStringField(s, 'body');
          s = _stripStringField(s, 'description');
          return _doParseJson(s);
        } catch (_) {}

        // 8. strip response + raw + body + description
        try {
          var s = _stripResponseArrays(input);
          s = _stripStringField(s, 'raw');
          s = _stripStringField(s, 'body');
          s = _stripStringField(s, 'description');
          return _doParseJson(s);
        } catch (_) {}

        // 9. nuclear option - strip most messy fields but KEEP structural ones (name, url, key)
        try {
          var s = input;
          for (var field in [
            'raw',
            'body',
            'description',
            'message',
            'text',
            'value',
          ]) {
            s = _stripStringField(s, field);
          }
          s = _stripResponseArrays(s);
          return _doParseJson(_lightFixJson(s));
        } catch (_) {}
      }
    }

    return _emptyCollection("Invalid JSON");
  }

  // ======================= STRIP RESPONSE ARRAYS =======================

  /// Removes every `"response": [...]` safely.
  static String _stripResponseArrays(String src) {
    final buf = StringBuffer();
    int i = 0;
    while (i < src.length) {
      if (src[i] == '"' && src.startsWith('"response"', i)) {
        int j = i + 10;
        while (j < src.length && _isWs(src[j])) {
          j++;
        }
        if (j < src.length && src[j] == ':') {
          j++;
          while (j < src.length && _isWs(src[j])) {
            j++;
          }
          if (j < src.length && src[j] == '[') {
            int depth = 1;
            j++;
            while (j < src.length && depth > 0) {
              if (src[j] == '"') {
                // Skip strings to avoid counting brackets inside them
                j++;
                while (j < src.length) {
                  if (src[j] == '\\' && j + 1 < src.length) {
                    j += 2;
                    continue;
                  }
                  if (src[j] == '"') {
                    j++;
                    break;
                  }
                  j++;
                }
                continue;
              }
              if (src[j] == '[') {
                depth++;
              } else if (src[j] == ']')
                depth--;
              j++;
            }
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

  // ======================= STRIP STRING FIELD =======================

  /// Replaces `"<fieldName>": "..."` with `"<fieldName>": ""`
  /// Safely skips the entire messy value to avoid leaving "tail" garbage.
  static String _stripStringField(String src, String fieldName) {
    final search = '"$fieldName"';
    final buf = StringBuffer();
    int i = 0;
    while (i < src.length) {
      if (src[i] == '"' && src.startsWith(search, i)) {
        int j = i + search.length;
        while (j < src.length && _isWs(src[j])) {
          j++;
        }
        if (j < src.length && src[j] == ':') {
          j++;
          while (j < src.length && _isWs(src[j])) {
            j++;
          }
          if (j < src.length && src[j] == '"') {
            // Found start of value string
            int k = j + 1;
            int innerBrackets = 0;
            bool isJson = false;
            int realEnd = -1;

            while (k < src.length) {
              if (src[k] == '\\' && k + 1 < src.length) {
                k += 2;
                continue;
              }
              if (!isJson && !_isWs(src[k])) {
                if (src[k] == '{' || src[k] == '[') isJson = true;
              }
              if (isJson) {
                if (src[k] == '{' || src[k] == '[') {
                  innerBrackets++;
                } else if (src[k] == '}' || src[k] == ']')
                  innerBrackets--;
              }

              // Check if this quote is a structural end
              if (src[k] == '"') {
                if (_isStructuralNext(src, k + 1, innerBrackets <= 0)) {
                  realEnd = k;
                  // If we are balanced, this is almost certainly the end.
                  if (innerBrackets <= 0) break;
                }
              }
              k++;
            }

            if (realEnd != -1) {
              buf.write('"$fieldName": ""');
              i = realEnd + 1;
              continue;
            }
          }
        }
      }
      buf.write(src[i]);
      i++;
    }
    return buf.toString();
  }

  // ======================= HELPERS =======================

  static bool _isWs(String c) =>
      c == ' ' || c == '\t' || c == '\n' || c == '\r';

  static String _lightFixJson(String input) {
    String out = input.trimLeft();
    if (out.startsWith('\uFEFF')) out = out.substring(1);
    out = out.replaceAll(RegExp(r',\s*}'), '}');
    out = out.replaceAll(RegExp(r',\s*]'), ']');
    // Remove duplicate commas
    out = out.replaceAll(RegExp(r',\s*,'), ',');
    return out;
  }

  // ======================= DO PARSE =======================

  static dynamic _doParseJson(String input) {
    var data = jsonDecode(input);
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

  static String _repairJson(String input) {
    if (input.length > 5000000) return input;
    String out = input.trim().replaceAll(
      RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'),
      '',
    );
    out = _fixUnescapedQuotesInValues(out);
    out = out.replaceAll(RegExp(r',\s*}'), '}');
    out = out.replaceAll(RegExp(r',\s*]'), ']');
    return out;
  }

  static String _fixUnescapedQuotesInValues(String src) {
    final buf = StringBuffer();
    const int stOutside = 0;
    const int stInKey = 1;
    const int stAfterKey = 2;
    const int stInValue = 3;
    int state = stOutside;
    bool expectValue = false;
    int innerBrackets = 0;
    bool looksLikeJson = false;

    int i = 0;
    while (i < src.length) {
      final ch = src[i];
      switch (state) {
        case stOutside:
          if (ch == '"') {
            buf.write(ch);
            state = expectValue ? stInValue : stInKey;
            innerBrackets = 0;
            looksLikeJson = false;
            expectValue = false;
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
          break;
        case stInKey:
          if (ch == '\\' && i + 1 < src.length) {
            buf.write(ch);
            buf.write(src[i + 1]);
            i += 2;
            continue;
          }
          buf.write(ch);
          if (ch == '"') state = stAfterKey;
          break;
        case stAfterKey:
          buf.write(ch);
          if (ch == ':') {
            expectValue = true;
            state = stOutside;
          } else if (!_isWs(ch)) {
            state = stOutside;
          }
          break;
        case stInValue:
          if (ch == '\\' && i + 1 < src.length) {
            buf.write(ch);
            buf.write(src[i + 1]);
            i += 2;
            continue;
          }

          if (!looksLikeJson && !_isWs(ch)) {
            if (ch == '{' || ch == '[') looksLikeJson = true;
          }

          if (looksLikeJson) {
            if (ch == '{' || ch == '[') {
              innerBrackets++;
            } else if (ch == '}' || ch == ']') {
              innerBrackets--;
            }
          }

          if (ch == '"') {
            // Check if this quote is structural.
            // A quote is structural if it's followed by , or } or ] AND it's balanced (if it looks like JSON).
            bool isLast = _isStructuralNext(src, i + 1, innerBrackets <= 0);

            if (isLast) {
              buf.write(ch);
              state = stOutside;
              expectValue = false;
            } else {
              buf.write('\\"');
            }
          } else {
            buf.write(ch);
          }
          break;
      }
      i++;
    }
    return buf.toString();
  }

  static bool _isStructuralNext(String src, int pos, [bool balanced = true]) {
    int j = pos;
    while (j < src.length && _isWs(src[j])) {
      j++;
    }
    if (j >= src.length) return true;
    final c = src[j];

    // Case 1: Immediately followed by } or ]
    if (c == '}' || c == ']') {
      if (balanced) return true;
      // If not balanced, check if this is the end of a field like "raw" or "body"
      // by looking ahead for the next Postman key.
      int k = j + 1;
      while (k < src.length && (_isWs(src[k]) || src[k] == ',')) {
        k++;
      }
      if (k < src.length && src[k] == '"') {
        // Look ahead for next key
        int m = k + 1;
        while (m < src.length && m < k + 300) {
          if (src[m] == '"') {
            int n = m + 1;
            while (n < src.length && _isWs(src[n])) {
              n++;
            }
            if (n < src.length && src[n] == ':') {
              final key = src.substring(k + 1, m).trim();
              if (_isTopLevelKey(key)) return true; // It's a structural end
            }
            break;
          }
          if (src[m] == '\\' && m + 1 < src.length) m++;
          m++;
        }
        return false;
      }
      return true;
    }

    // Case 2: Followed by a comma
    if (c == ',') {
      int k = j + 1;
      while (k < src.length && _isWs(src[k])) {
        k++;
      }
      if (k >= src.length) return true;

      // If it's a comma followed by a quote (potential next key)
      if (src[k] == '"') {
        int m = k + 1;
        while (m < src.length && m < k + 300) {
          if (src[m] == '"') {
            int n = m + 1;
            while (n < src.length && _isWs(src[n])) {
              n++;
            }
            if (n < src.length && src[n] == ':') {
              final key = src.substring(k + 1, m).trim();
              if (_isTopLevelKey(key))
                return true; // Always structural if top-level key follows
              if (balanced && _isKnownPostmanKey(key)) return true;
              return false;
            }
            break;
          }
          if (src[m] == '\\' && m + 1 < src.length) {
            m++;
          }
          m++;
        }
      } else if (src[k] == '{' ||
          src[k] == '[' ||
          src[k] == '}' ||
          src[k] == ']') {
        return true;
      }
    }
    return false;
  }

  static bool _isTopLevelKey(String key) {
    return const {
      'info',
      'item',
      'request',
      'response',
      'name',
      'event',
      'variable',
      'description',
      'auth',
      'protocolProfileBehavior',
      'options',
    }.contains(key);
  }

  static bool _isKnownPostmanKey(String key) {
    const keys = {
      'info',
      'item',
      'name',
      'request',
      'response',
      'header',
      'url',
      'method',
      'body',
      'description',
      'raw',
      'mode',
      'options',
      'variable',
      'auth',
      'event',
      'protocolProfileBehavior',
      'key',
      'value',
      'type',
      'id',
      'requests',
      'folders',
      'createdAt',
      'updatedAt',
      'collection',
      // 'status', // Removed as it's common in API responses
      // 'code',   // Removed as it's common in API responses
      'listen',
      'script',
      'exec',
      'formdata',
      'urlencoded',
      'file',
      'graphql',
      'src',
      'disabled',
      'originalRequest',
      '_postman_id',
      '_postman_previewlanguage',
      'cookie',
      'path',
      'host',
      'port',
      'query',
      'protocol',
      'version',
      'schema',
    };
    return keys.contains(key);
  }

  // ======================= NORMALIZER =======================

  static CollectionModel _normalizePostman(Map<String, dynamic> data) {
    final info = data["info"] ?? {};
    final String rootName = info["name"]?.toString() ?? "Imported Collection";
    final items = data["item"];
    debugPrint("Normalizing Postman collection: $rootName");

    int requestCounter = 0;
    final List<HttpRequestModel> rootRequests = [];
    final List<CollectionModel> subCollections = [];

    CollectionModel buildFolder(Map<String, dynamic> folderItem) {
      final folderName = folderItem["name"]?.toString() ?? "Folder";
      final List<HttpRequestModel> folderRequests = [];
      final List<CollectionModel> nestedSubs = [];
      final subItems = folderItem["item"];
      if (subItems is List) {
        for (var sub in subItems) {
          if (sub is! Map<String, dynamic>) continue;
          if (sub.containsKey("item")) {
            nestedSubs.add(buildFolder(sub));
          } else if (sub.containsKey("request")) {
            folderRequests.add(_convertPostmanRequest(sub, requestCounter++));
          }
        }
      }
      return CollectionModel(
        id: "${DateTime.now().millisecondsSinceEpoch}_${folderName.hashCode}",
        name: folderName,
        requests: folderRequests,
        folders: nestedSubs,
      );
    }

    if (items is List) {
      for (var item in items) {
        if (item is! Map<String, dynamic>) continue;
        if (item.containsKey("item")) {
          subCollections.add(buildFolder(item));
        } else if (item.containsKey("request")) {
          rootRequests.add(_convertPostmanRequest(item, requestCounter++));
        }
      }
    }

    debugPrint(
      "Root requests: ${rootRequests.length}, "
      "sub-collections: ${subCollections.length}",
    );

    final collectionBaseUrl = _extractPostmanCollectionBaseUrl(data);

    return CollectionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: rootName,
      baseUrl: collectionBaseUrl,
      requests: rootRequests,
      folders: subCollections,
    );
  }

  static String? _extractPostmanCollectionBaseUrl(Map<String, dynamic> data) {
    final variables = data['variable'];
    if (variables is! List) return null;

    for (final item in variables) {
      if (item is! Map<String, dynamic>) continue;
      final key = item['key']?.toString() ?? '';
      if (EnvironmentMixin.isBaseUrlVariable(key)) {
        final value = item['value']?.toString() ?? '';
        if (value.isNotEmpty) return value;
      }
    }
    return null;
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
          final k = h["key"]?.toString() ?? "";
          final v = h["value"]?.toString() ?? "";
          if (k.isNotEmpty) headers[k] = v;
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

    final methodMatch = RegExp(
      r'(?:-X|--request)\s+([A-Z]+)',
    ).firstMatch(input);
    if (methodMatch != null) method = methodMatch.group(1)!;

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

    final dataMatch = RegExp(
      r'''(?:-d|--data|--data-raw|--data-binary)\s+['"]([^'"]{0,10485760})['"]''',
    ).firstMatch(input);
    if (dataMatch != null) {
      body = dataMatch.group(1)!;
      if (method == "GET") method = "POST";
    }

    final urlMatch = RegExp(
      r'''['"]?(https?://[^\s'"]{1,2000})['"]?''',
    ).firstMatch(input);
    if (urlMatch != null) url = urlMatch.group(1) ?? "";

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

  static HttpRequestModel _parseUrl(String input) => HttpRequestModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: "Imported URL",
    method: "GET",
    url: input.trim(),
    createdAt: DateTime.now(),
  );

  static HttpRequestModel _parseRaw(String input) => HttpRequestModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: "Imported Raw",
    method: "POST",
    url: "",
    body: input.trim(),
    createdAt: DateTime.now(),
  );

  static HttpRequestModel _parseGrpc(String input) => HttpRequestModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: "Imported gRPC",
    method: "POST",
    url: "",
    body: input.trim(),
    createdAt: DateTime.now(),
  );

  static CollectionModel _emptyCollection(String name) => CollectionModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: name,
    requests: [],
  );
}
