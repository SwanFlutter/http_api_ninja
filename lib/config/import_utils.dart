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
    // First attempt: parse as-is
    try {
      return _doParseJson(input);
    } catch (_) {}

    // Second attempt: light cleanup only (no heavy regex on large strings)
    try {
      final lightFixed = _lightFixJson(input);
      return _doParseJson(lightFixed);
    } catch (_) {}

    // Third attempt: full repair (only for smaller inputs to avoid OOM)
    if (input.length <= 500000) {
      try {
        final repaired = _repairJson(input);
        return _doParseJson(repaired);
      } catch (e) {
        debugPrint("Repair failed: $e");
      }
    }

    return _emptyCollection("Invalid JSON");
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
    String out = input.trim();

    // 1. Fix Postman {{var}} → "var"
    //    Use a non-greedy match but limit to avoid backtracking on huge input.
    out = out.replaceAllMapped(
      RegExp(r'\{\{([^}]{1,200})\}\}'),
      (m) => '"${m.group(1)}"',
    );

    // 2. Fix duplicated quotes ""value""
    out = out.replaceAllMapped(
      RegExp(r'""([^"]{0,500})""'),
      (m) => '"${m.group(1)}"',
    );

    // 3. Remove illegal control characters (keep \t \n \r)
    out = out.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'), '');

    // 4. Fix unquoted keys — only safe on smaller strings
    if (out.length <= 200000) {
      out = out.replaceAllMapped(
        RegExp(r'([{,]\s*)([a-zA-Z_][a-zA-Z0-9_]*)(\s*:)'),
        (m) => '${m.group(1)}"${m.group(2)}"${m.group(3)}',
      );
    }

    // 5. Remove trailing commas
    out = out.replaceAll(RegExp(r',\s*}'), '}');
    out = out.replaceAll(RegExp(r',\s*]'), ']');

    return out;
  }

  // ======================= NORMALIZER =======================

  /// Converts a Postman collection into a single root [CollectionModel].
  /// Top-level folders become [subCollections]; loose root requests stay on
  /// the root collection itself.
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
        subCollections: nestedSubs,
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
      "Root requests: ${rootRequests.length}, sub-collections: ${subCollections.length}",
    );

    return CollectionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: rootName,
      requests: rootRequests,
      subCollections: subCollections,
    );
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
