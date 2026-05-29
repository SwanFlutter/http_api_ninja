import 'dart:convert';

import '../controller/environment_mixin.dart';
import '../models/collection_model.dart';
import '../models/http_request_model.dart';

/// Postman Collection v2.1 export/import and bulk workspace helpers.
class PostmanCollectionUtils {
  static const _schema =
      'https://schema.getpostman.com/json/collection/v2.1.0/collection.json';

  /// Export one [CollectionModel] as Postman v2.1 JSON map.
  static Map<String, dynamic> toPostmanCollection(CollectionModel collection) {
    final items = <Map<String, dynamic>>[
      ...collection.folders.map(_folderToPostmanItem),
      ...collection.requests.map(_requestToPostmanItem),
    ];

    final variables = <Map<String, dynamic>>[];
    if (collection.baseUrl != null && collection.baseUrl!.isNotEmpty) {
      variables.add({
        'key': 'baseUrl',
        'value': collection.baseUrl,
        'type': 'string',
      });
    }

    return {
      'info': {
        'name': collection.name,
        '_postman_id': collection.id,
        'schema': _schema,
      },
      if (variables.isNotEmpty) 'variable': variables,
      'item': items,
    };
  }

  /// Export all collections as one Postman collection (folders = each collection).
  static Map<String, dynamic> toPostmanWorkspace(
    List<CollectionModel> collections, {
    String name = 'HTTP API Ninja Export',
  }) {
    return {
      'info': {
        'name': name,
        '_postman_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'schema': _schema,
      },
      'item': collections.map(_collectionAsPostmanFolder).toList(),
    };
  }

  /// Native app backup format (re-import into HTTP API Ninja).
  static Map<String, dynamic> toAppBackup(List<CollectionModel> collections) {
    return {
      'format': 'http_api_ninja_backup',
      'version': '1.1.4',
      'exportedAt': DateTime.now().toIso8601String(),
      'collections': collections.map((c) => c.toJson()).toList(),
    };
  }

  static String exportCollectionJson(CollectionModel collection) {
    return const JsonEncoder.withIndent('  ').convert(toPostmanCollection(collection));
  }

  static String exportAllPostmanJson(List<CollectionModel> collections) {
    return const JsonEncoder.withIndent('  ')
        .convert(toPostmanWorkspace(collections));
  }

  static String exportAllAppBackupJson(List<CollectionModel> collections) {
    return const JsonEncoder.withIndent('  ').convert(toAppBackup(collections));
  }

  /// Parse JSON string; returns list of collections to import.
  static List<CollectionModel> parseImportPayload(String jsonString) {
    final data = jsonDecode(jsonString.trim());

    if (data is Map<String, dynamic>) {
      if (data['format'] == 'http_api_ninja_backup' &&
          data['collections'] is List) {
        return (data['collections'] as List)
            .whereType<Map<String, dynamic>>()
            .map(CollectionModel.fromJson)
            .toList();
      }

      if (data['collections'] is List &&
          (data['collections'] as List).isNotEmpty) {
        final first = (data['collections'] as List).first;
        if (first is Map<String, dynamic> &&
            (first.containsKey('info') || first.containsKey('item'))) {
          return (data['collections'] as List)
              .whereType<Map<String, dynamic>>()
              .map(_postmanMapToCollection)
              .toList();
        }
        return (data['collections'] as List)
            .whereType<Map<String, dynamic>>()
            .map(CollectionModel.fromJson)
            .toList();
      }

      if (data.containsKey('info') || data.containsKey('item')) {
        return [_postmanMapToCollection(data)];
      }

      if (data.containsKey('requests') && data.containsKey('name')) {
        return [CollectionModel.fromJson(data)];
      }
    }

    if (data is List) {
      if (data.isEmpty) return [];
      final first = data.first;
      if (first is Map<String, dynamic>) {
        if (first.containsKey('info') || first.containsKey('item')) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(_postmanMapToCollection)
              .toList();
        }
        return data
            .whereType<Map<String, dynamic>>()
            .map(CollectionModel.fromJson)
            .toList();
      }
    }

    throw FormatException('Unsupported import format');
  }

  static Map<String, dynamic> _collectionAsPostmanFolder(
    CollectionModel collection,
  ) {
    return {
      'name': collection.name,
      'item': [
        ...collection.folders.map(_folderToPostmanItem),
        ...collection.requests.map(_requestToPostmanItem),
      ],
    };
  }

  static Map<String, dynamic> _folderToPostmanItem(CollectionModel folder) {
    return {
      'name': folder.name,
      'item': [
        ...folder.folders.map(_folderToPostmanItem),
        ...folder.requests.map(_requestToPostmanItem),
      ],
    };
  }

  static Map<String, dynamic> _requestToPostmanItem(HttpRequestModel request) {
    final headerList = request.headers.entries
        .map(
          (e) => {
            'key': e.key,
            'value': e.value,
            'type': 'text',
          },
        )
        .toList();

    final Map<String, dynamic> bodyMap;
    if (request.body != null && request.body!.isNotEmpty) {
      bodyMap = {
        'mode': 'raw',
        'raw': request.body,
        'options': {
          'raw': {'language': 'json'},
        },
      };
    } else {
      bodyMap = {};
    }

    final method = request.method.toUpperCase();
    final Map<String, dynamic> postmanRequest = {
      'method': method,
      'header': headerList,
      'url': request.url,
    };

    if (bodyMap.isNotEmpty &&
        !{'GET', 'HEAD'}.contains(method)) {
      postmanRequest['body'] = bodyMap;
    }

    return {
      'name': request.name,
      'request': postmanRequest,
    };
  }

  static CollectionModel _postmanMapToCollection(Map<String, dynamic> data) {
    final info = data['info'] as Map<String, dynamic>? ?? {};
    final name = info['name']?.toString() ?? 'Imported Collection';
    final id =
        info['_postman_id']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();

    String? baseUrl;
    final variables = data['variable'];
    if (variables is List) {
      for (final item in variables) {
        if (item is! Map<String, dynamic>) continue;
        final key = item['key']?.toString() ?? '';
        if (EnvironmentMixin.isBaseUrlVariable(key)) {
          baseUrl = item['value']?.toString();
          break;
        }
      }
    }

    final items = data['item'] as List? ?? [];
    final rootRequests = <HttpRequestModel>[];
    final folders = <CollectionModel>[];
    var index = 0;

    for (final item in items) {
      if (item is! Map<String, dynamic>) continue;
      if (item.containsKey('request')) {
        rootRequests.add(_postmanItemToRequest(item, index++));
      } else if (item.containsKey('item')) {
        folders.add(_postmanFolderToCollection(item, index));
      }
    }

    return CollectionModel(
      id: id,
      name: name,
      baseUrl: baseUrl,
      requests: rootRequests,
      folders: folders,
    );
  }

  static CollectionModel _postmanFolderToCollection(
    Map<String, dynamic> folderItem,
    int seed,
  ) {
    final folderName = folderItem['name']?.toString() ?? 'Folder';
    final folderRequests = <HttpRequestModel>[];
    final nestedSubs = <CollectionModel>[];
    var index = seed * 1000;
    final subItems = folderItem['item'] as List? ?? [];

    for (final sub in subItems) {
      if (sub is! Map<String, dynamic>) continue;
      if (sub.containsKey('item')) {
        nestedSubs.add(_postmanFolderToCollection(sub, index++));
      } else if (sub.containsKey('request')) {
        folderRequests.add(_postmanItemToRequest(sub, index++));
      }
    }

    return CollectionModel(
      id: '${DateTime.now().millisecondsSinceEpoch}_${folderName.hashCode}',
      name: folderName,
      requests: folderRequests,
      folders: nestedSubs,
    );
  }

  static HttpRequestModel _postmanItemToRequest(
    Map<String, dynamic> item,
    int index,
  ) {
    final req = item['request'] as Map<String, dynamic>? ?? {};
    final name = item['name']?.toString() ?? 'Request';
    final method = req['method']?.toString() ?? 'GET';
    final headers = <String, String>{};
    String url = '';
    String? body;

    final urlData = req['url'];
    if (urlData is String) {
      url = urlData;
    } else if (urlData is Map<String, dynamic>) {
      url = urlData['raw']?.toString() ?? '';
      if (url.isEmpty && urlData['host'] is List) {
        final host = (urlData['host'] as List).join('.');
        final path =
            (urlData['path'] as List?)?.map((e) => e.toString()).join('/') ??
            '';
        final protocol = urlData['protocol']?.toString() ?? 'https';
        url = '$protocol://$host/$path';
      }
    }

    final headerList = req['header'];
    if (headerList is List) {
      for (final h in headerList) {
        if (h is Map<String, dynamic>) {
          final k = h['key']?.toString() ?? '';
          final v = h['value']?.toString() ?? '';
          if (k.isNotEmpty) headers[k] = v;
        }
      }
    }

    final bodyData = req['body'];
    if (bodyData is Map<String, dynamic>) {
      if (bodyData['mode'] == 'raw') {
        body = bodyData['raw']?.toString();
      }
    }

    return HttpRequestModel(
      id: '${DateTime.now().millisecondsSinceEpoch}_$index',
      name: name,
      method: method,
      url: url,
      headers: headers,
      body: body,
      bodyType: body != null && body.isNotEmpty ? 'JSON' : null,
      createdAt: DateTime.now(),
    );
  }
}
