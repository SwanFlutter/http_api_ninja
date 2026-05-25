import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';
import '../models/collection_model.dart';
import '../models/http_request_model.dart';

mixin CollectionMixin {
  final storage = GetXStorage();

  final RxList<CollectionModel> collections = <CollectionModel>[].obs;
  final Rx<HttpRequestModel?> selectedRequest = Rx<HttpRequestModel?>(null);

  // These will be provided by the main controller or other mixins
  void showNotification(String message, String type);
  RxString get httpMethod;
  RxString get url;
  RxMap<String, String> get headers;
  RxMap<String, String> get queryParams;
  RxString get bodyType;
  void setBodyForType(String newBody);
  String getRequestBody();
  void syncHeadersListFromMap();

  void loadCollections() {
    final savedCollections = storage.readList<Map<String, dynamic>>(
      key: 'collections',
    );
    if (savedCollections != null && savedCollections.isNotEmpty) {
      collections.value = savedCollections
          .map((c) => CollectionModel.fromJson(c))
          .toList();
    }
  }

  void saveCollections() {
    storage.writeList(
      key: 'collections',
      value: collections.map((c) => c.toJson()).toList(),
    );
  }

  void selectRequest(HttpRequestModel request) {
    // Save current request before switching
    if (selectedRequest.value != null) {
      saveCurrentRequest();
    }

    selectedRequest.value = request;
    httpMethod.value = request.method;
    url.value = request.url;
    headers.value = RxMap<String, String>(request.headers);
    queryParams.value = RxMap<String, String>(request.queryParams);
    if (request.body != null && request.body!.isNotEmpty) {
      bodyType.value = 'JSON';
      setBodyForType(request.body!);
    }

    syncHeadersListFromMap();
  }

  void saveCurrentRequest() {
    if (selectedRequest.value == null) return;

    final currentId = selectedRequest.value!.id;
    final currentBody = getRequestBody();
    var saved = false;

    List<CollectionModel> updateInTree(List<CollectionModel> nodes) {
      return nodes.map((node) {
        final requestIndex = node.requests.indexWhere((r) => r.id == currentId);
        if (requestIndex != -1) {
          saved = true;
          final updatedRequest = node.requests[requestIndex].copyWith(
            method: httpMethod.value,
            url: url.value,
            headers: Map<String, String>.from(headers),
            queryParams: Map<String, String>.from(queryParams),
            body: currentBody.isEmpty ? null : currentBody,
            lastUsed: DateTime.now(),
          );
          final updatedRequests = List<HttpRequestModel>.from(node.requests);
          updatedRequests[requestIndex] = updatedRequest;
          return node.copyWith(requests: updatedRequests);
        }
        if (node.folders.isNotEmpty) {
          final updatedFolders = updateInTree(node.folders);
          if (saved) return node.copyWith(folders: updatedFolders);
        }
        return node;
      }).toList();
    }

    collections.value = updateInTree(collections);
    if (saved) saveCollections();
  }

  void toggleCollection(String collectionId) {
    bool toggled = false;

    List<CollectionModel> updateRecursive(List<CollectionModel> list) {
      return list.map((c) {
        if (c.id == collectionId) {
          toggled = true;
          return c.copyWith(isExpanded: !c.isExpanded);
        }
        if (c.folders.isNotEmpty) {
          return c.copyWith(folders: updateRecursive(c.folders));
        }
        return c;
      }).toList();
    }

    final newList = updateRecursive(collections);
    if (toggled) {
      collections.value = newList;
      saveCollections();
    }
  }

  void addCollection(String name, {String? baseUrl}) {
    final collection = CollectionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      baseUrl: baseUrl,
      requests: [],
    );
    collections.add(collection);
    saveCollections();
  }

  void importCollection(CollectionModel collection) {
    collections.add(collection);
    saveCollections();
    showNotification('Collection "${collection.name}" imported', 'success');
  }

  void exportCollection(CollectionModel collection) {
    try {
      final json = const JsonEncoder.withIndent(
        '  ',
      ).convert(collection.toJson());
      Clipboard.setData(ClipboardData(text: json));
      showNotification('Collection JSON copied to clipboard', 'success');
    } catch (e) {
      showNotification('Export failed: $e', 'error');
    }
  }

  void updateCollectionBaseUrl(String collectionId, String? baseUrl) {
    final index = collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      collections[index] = collections[index].copyWith(baseUrl: baseUrl);
      saveCollections();
    }
  }

  /// Get the base URL for the collection that contains the selected request
  /// (including requests inside nested folders; inherits from parent collection).
  String? getSelectedRequestBaseUrl() {
    if (selectedRequest.value == null) return null;

    for (var collection in collections) {
      final baseUrl = _findRequestBaseUrl(
        collection,
        selectedRequest.value!.id,
        collection.baseUrl,
      );
      if (baseUrl != null) return baseUrl;
    }
    return null;
  }

  /// Returns inherited base URL when [requestId] is found under [node].
  String? _findRequestBaseUrl(
    CollectionModel node,
    String requestId,
    String? inheritedBaseUrl,
  ) {
    final effectiveBase =
        (node.baseUrl != null && node.baseUrl!.isNotEmpty)
            ? node.baseUrl
            : inheritedBaseUrl;

    if (node.requests.any((r) => r.id == requestId)) {
      return effectiveBase;
    }

    for (final folder in node.folders) {
      final found = _findRequestBaseUrl(folder, requestId, effectiveBase);
      if (found != null) return found;
    }
    return null;
  }

  /// Variable overrides from the owning collection's base URL.
  Map<String, String> getCollectionVariableOverrides() {
    final base = getSelectedRequestBaseUrl();
    if (base == null || base.isEmpty) return {};
    return {
      'baseUrl': base,
      'base_url': base,
      'BASE_URL': base,
      'BASEURL': base,
    };
  }

  static final RegExp _baseUrlTemplatePattern = RegExp(
    r'\{\{\s*base[_\-.]?url\s*\}\}',
    caseSensitive: false,
  );

  static bool urlUsesBaseUrlTemplate(String url) =>
      _baseUrlTemplatePattern.hasMatch(url);

  /// Build full URL with collection base URL
  String buildUrlWithBase(String path) {
    if (path.contains('{{')) return path;

    final baseUrl = getSelectedRequestBaseUrl();
    if (baseUrl == null || baseUrl.isEmpty) return path;

    // If path already starts with http/https, don't prepend base URL
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // Ensure proper URL joining
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final endpoint = path.startsWith('/') ? path : '/$path';
    return '$base$endpoint';
  }

  void addRequest(String collectionId, HttpRequestModel request) {
    final index = collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      final updatedRequests = [...collections[index].requests, request];
      collections[index] = collections[index].copyWith(
        requests: updatedRequests,
      );
      saveCollections();
    }
  }

  void deleteRequest(String collectionId, String requestId) {
    final index = collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      final updatedRequests = collections[index].requests
          .where((r) => r.id != requestId)
          .toList();
      collections[index] = collections[index].copyWith(
        requests: updatedRequests,
      );
      saveCollections();
    }
  }

  void deleteCollection(String collectionId) {
    collections.removeWhere((c) => c.id == collectionId);
    saveCollections();
  }

  void renameCollection(String collectionId, String newName) {
    final index = collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      collections[index] = collections[index].copyWith(name: newName);
      saveCollections();
    }
  }

  void initializeSampleData() {
    if (collections.isEmpty) {
      collections.addAll([
        CollectionModel(
          id: 'user',
          name: 'User',
          requests: [
            HttpRequestModel(
              id: 'welcome',
              name: 'Welcome',
              method: 'GET',
              url: 'https://www.thunderclient.com/welcome',
              createdAt: DateTime.now().subtract(const Duration(days: 7)),
            ),
          ],
        ),
        CollectionModel(
          id: 'orders',
          name: 'Orders',
          requests: [
            HttpRequestModel(
              id: 'get-orders',
              name: 'Get Orders',
              method: 'GET',
              url: 'https://api.example.com/orders',
              createdAt: DateTime.now().subtract(const Duration(days: 7)),
            ),
          ],
        ),
      ]);
      saveCollections();
    }
  }
}
