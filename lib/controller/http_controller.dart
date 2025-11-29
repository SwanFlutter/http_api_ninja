import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';

import '../models/collection_model.dart';
import '../models/environment_model.dart';
import '../models/history_model.dart';
import '../models/http_request_model.dart';
import '../models/http_response_model.dart';

class HttpController extends GetXController {
  final storage = GetXStorage();
  final GetConnect _connect = GetConnect();

  // Observable variables
  final RxList<CollectionModel> collections = <CollectionModel>[].obs;
  final Rx<HttpRequestModel?> selectedRequest = Rx<HttpRequestModel?>(null);
  final Rx<HttpResponseModel?> currentResponse = Rx<HttpResponseModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedTab = 'activity'.obs;
  final RxString selectedRequestTab = 'Query'.obs;
  final RxString selectedResponseTab = 'Response'.obs;
  final RxBool showTerminal = true.obs;

  // Request builder fields
  final RxString httpMethod = 'GET'.obs;
  final RxString url = ''.obs;
  final RxMap<String, String> headers = <String, String>{}.obs;
  final RxMap<String, String> queryParams = <String, String>{}.obs;
  final RxString body = ''.obs;

  // Headers management
  final RxList<Map<String, dynamic>> headersList = <Map<String, dynamic>>[
    {'enabled': true, 'key': 'User-Agent', 'value': 'HTTP API Ninja/1.0'},
  ].obs;

  // Auth management
  final RxString authType = 'None'.obs;
  final RxString authUsername = ''.obs;
  final RxString authPassword = ''.obs;
  final RxString authToken = ''.obs;

  // Body management
  final RxString bodyType = 'None'.obs;
  final RxList<Map<String, dynamic>> formDataList =
      <Map<String, dynamic>>[].obs;

  // Tests management
  final RxList<Map<String, dynamic>> testsList = <Map<String, dynamic>>[].obs;

  // Pre-run script
  final RxString preRunScript = ''.obs;

  // Environment Variables
  final RxList<EnvironmentModel> environments = <EnvironmentModel>[].obs;
  final Rx<EnvironmentModel?> activeEnvironment = Rx<EnvironmentModel?>(null);
  final Rx<GlobalVariablesModel> globalVariables = GlobalVariablesModel().obs;

  // History
  final RxList<HistoryModel> history = <HistoryModel>[].obs;
  final RxString historySearchQuery = ''.obs;
  final RxString historyFilterMethod = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCollections();
    _loadEnvironments();
    _loadHistory();
    _initializeSampleData();
  }

  void _loadCollections() {
    final savedCollections = storage.readList<Map<String, dynamic>>(
      key: 'collections',
    );
    if (savedCollections != null && savedCollections.isNotEmpty) {
      collections.value = savedCollections
          .map((c) => CollectionModel.fromJson(c))
          .toList();
    }
  }

  void _saveCollections() {
    storage.writeList(
      key: 'collections',
      value: collections.map((c) => c.toJson()).toList(),
    );
  }

  // ==================== Environment Methods ====================

  void _loadEnvironments() {
    // Load environments
    final savedEnvs = storage.readList<Map<String, dynamic>>(
      key: 'environments',
    );
    if (savedEnvs != null && savedEnvs.isNotEmpty) {
      environments.value = savedEnvs
          .map((e) => EnvironmentModel.fromJson(e))
          .toList();
      // Set active environment
      final active = environments.cast<EnvironmentModel>().firstWhere(
        (e) => e.isActive,
        orElse: () => environments.first,
      );
      activeEnvironment.value = active;
    } else {
      // Create default environments
      _initializeDefaultEnvironments();
    }

    // Load global variables
    final savedGlobals = storage.read<Map<String, dynamic>>(
      key: 'globalVariables',
    );
    if (savedGlobals != null) {
      globalVariables.value = GlobalVariablesModel.fromJson(savedGlobals);
    }
  }

  void _initializeDefaultEnvironments() {
    environments.addAll([
      EnvironmentModel(
        id: 'dev',
        name: 'Development',
        variables: {'base_url': 'http://localhost:3000', 'api_version': 'v1'},
        isActive: true,
        createdAt: DateTime.now(),
      ),
      EnvironmentModel(
        id: 'staging',
        name: 'Staging',
        variables: {
          'base_url': 'https://staging.example.com',
          'api_version': 'v1',
        },
        createdAt: DateTime.now(),
      ),
      EnvironmentModel(
        id: 'prod',
        name: 'Production',
        variables: {'base_url': 'https://api.example.com', 'api_version': 'v1'},
        createdAt: DateTime.now(),
      ),
    ]);
    activeEnvironment.value = environments.first;
    _saveEnvironments();
  }

  void _saveEnvironments() {
    storage.writeList(
      key: 'environments',
      value: environments.map((e) => e.toJson()).toList(),
    );
  }

  void _saveGlobalVariables() {
    storage.write(
      key: 'globalVariables',
      value: globalVariables.value.toJson(),
    );
  }

  void addEnvironment(String name) {
    final env = EnvironmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      variables: {},
      createdAt: DateTime.now(),
    );
    environments.add(env);
    _saveEnvironments();
  }

  void deleteEnvironment(String id) {
    environments.removeWhere((e) => e.id == id);
    if (activeEnvironment.value?.id == id) {
      activeEnvironment.value = environments.isNotEmpty
          ? environments.first
          : null;
      if (activeEnvironment.value != null) {
        setActiveEnvironment(activeEnvironment.value!.id);
      }
    }
    _saveEnvironments();
  }

  void renameEnvironment(String id, String newName) {
    final index = environments.indexWhere((e) => e.id == id);
    if (index != -1) {
      environments[index] = environments[index].copyWith(
        name: newName,
        updatedAt: DateTime.now(),
      );
      _saveEnvironments();
    }
  }

  void setActiveEnvironment(String id) {
    for (var i = 0; i < environments.length; i++) {
      environments[i] = environments[i].copyWith(
        isActive: environments[i].id == id,
      );
    }
    activeEnvironment.value = environments.cast<EnvironmentModel>().firstWhere(
      (e) => e.id == id,
      orElse: () => environments.first,
    );
    _saveEnvironments();
  }

  void addEnvironmentVariable(String envId, String key, String value) {
    final index = environments.indexWhere((e) => e.id == envId);
    if (index != -1) {
      final newVars = Map<String, String>.from(environments[index].variables);
      newVars[key] = value;
      environments[index] = environments[index].copyWith(
        variables: newVars,
        updatedAt: DateTime.now(),
      );
      _saveEnvironments();
    }
  }

  void updateEnvironmentVariable(
    String envId,
    String oldKey,
    String newKey,
    String value,
  ) {
    final index = environments.indexWhere((e) => e.id == envId);
    if (index != -1) {
      final newVars = Map<String, String>.from(environments[index].variables);
      newVars.remove(oldKey);
      newVars[newKey] = value;
      environments[index] = environments[index].copyWith(
        variables: newVars,
        updatedAt: DateTime.now(),
      );
      _saveEnvironments();
    }
  }

  void deleteEnvironmentVariable(String envId, String key) {
    final index = environments.indexWhere((e) => e.id == envId);
    if (index != -1) {
      final newVars = Map<String, String>.from(environments[index].variables);
      newVars.remove(key);
      environments[index] = environments[index].copyWith(
        variables: newVars,
        updatedAt: DateTime.now(),
      );
      _saveEnvironments();
    }
  }

  void addGlobalVariable(String key, String value) {
    final newVars = Map<String, String>.from(globalVariables.value.variables);
    newVars[key] = value;
    globalVariables.value = globalVariables.value.copyWith(
      variables: newVars,
      updatedAt: DateTime.now(),
    );
    _saveGlobalVariables();
  }

  void updateGlobalVariable(String oldKey, String newKey, String value) {
    final newVars = Map<String, String>.from(globalVariables.value.variables);
    newVars.remove(oldKey);
    newVars[newKey] = value;
    globalVariables.value = globalVariables.value.copyWith(
      variables: newVars,
      updatedAt: DateTime.now(),
    );
    _saveGlobalVariables();
  }

  void deleteGlobalVariable(String key) {
    final newVars = Map<String, String>.from(globalVariables.value.variables);
    newVars.remove(key);
    globalVariables.value = globalVariables.value.copyWith(
      variables: newVars,
      updatedAt: DateTime.now(),
    );
    _saveGlobalVariables();
  }

  /// Replace {{variable}} placeholders with actual values
  String replaceVariables(String input) {
    if (!input.contains('{{')) return input;

    String result = input;
    final regex = RegExp(r'\{\{(\w+)\}\}');

    result = result.replaceAllMapped(regex, (match) {
      final varName = match.group(1)!;

      // First check active environment
      if (activeEnvironment.value != null) {
        final envValue = activeEnvironment.value!.getVariable(varName);
        if (envValue != null) return envValue;
      }

      // Then check global variables
      final globalValue = globalVariables.value.variables[varName];
      if (globalValue != null) return globalValue;

      // Return original if not found
      return match.group(0)!;
    });

    return result;
  }

  /// Export environment to JSON
  String exportEnvironment(String envId) {
    final envIndex = environments.indexWhere((e) => e.id == envId);
    final env = envIndex != -1 ? environments[envIndex] : null;
    if (env == null) return '{}';
    return jsonEncode(env.toJson());
  }

  /// Import environment from JSON
  void importEnvironment(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final env = EnvironmentModel.fromJson(json);
      // Generate new ID to avoid conflicts
      final newEnv = env.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );
      environments.add(newEnv);
      _saveEnvironments();
      showNotification('Environment imported successfully', 'success');
    } catch (e) {
      showNotification('Failed to import environment: $e', 'error');
    }
  }

  // ==================== History Methods ====================

  void _loadHistory() {
    final savedHistory = storage.readList<Map<String, dynamic>>(key: 'history');
    if (savedHistory != null && savedHistory.isNotEmpty) {
      history.value = savedHistory
          .map((h) => HistoryModel.fromJson(h))
          .toList();
    }
  }

  void _saveHistory() {
    storage.writeList(
      key: 'history',
      value: history.map((h) => h.toJson()).toList(),
    );
  }

  void addToHistory(HistoryModel item) {
    // Add to beginning of list
    history.insert(0, item);

    // Keep only last 100 items
    if (history.length > 100) {
      history.removeRange(100, history.length);
    }

    _saveHistory();
  }

  void deleteHistoryItem(String id) {
    history.removeWhere((h) => h.id == id);
    _saveHistory();
  }

  void clearHistory() {
    history.clear();
    _saveHistory();
  }

  void clearHistoryByMethod(String method) {
    history.removeWhere((h) => h.method == method);
    _saveHistory();
  }

  void clearHistoryOlderThan(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    history.removeWhere((h) => h.timestamp.isBefore(cutoff));
    _saveHistory();
  }

  /// Get filtered history based on search and method filter
  List<HistoryModel> get filteredHistory {
    var result = history.toList();

    // Filter by method
    if (historyFilterMethod.value != 'All') {
      result = result
          .where((h) => h.method == historyFilterMethod.value)
          .toList();
    }

    // Filter by search query
    if (historySearchQuery.value.isNotEmpty) {
      final query = historySearchQuery.value.toLowerCase();
      result = result
          .where(
            (h) =>
                h.url.toLowerCase().contains(query) ||
                (h.requestName?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }

    return result;
  }

  /// Load history item into request builder
  void loadFromHistory(HistoryModel item) {
    httpMethod.value = item.method;
    url.value = item.url;
    headers.value = RxMap<String, String>(item.headers);
    queryParams.value = RxMap<String, String>(item.queryParams);
    body.value = item.body ?? '';

    // Sync headers list
    headersList.clear();
    item.headers.forEach((key, value) {
      headersList.add({'enabled': true, 'key': key, 'value': value});
    });
    if (headersList.isEmpty) {
      headersList.add({
        'enabled': true,
        'key': 'User-Agent',
        'value': 'HTTP API Ninja/1.0',
      });
    }
  }

  void _initializeSampleData() {
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
      _saveCollections();
    }
  }

  // Notification messages
  final RxString notificationMessage = ''.obs;
  final RxString notificationType = ''.obs; // 'success', 'error', 'info'

  void showNotification(String message, String type) {
    notificationMessage.value = message;
    notificationType.value = type;

    // Auto clear after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      notificationMessage.value = '';
      notificationType.value = '';
    });
  }

  Future<void> sendRequest() async {
    if (url.value.isEmpty) {
      showNotification('Please enter a URL', 'error');
      return;
    }

    isLoading.value = true;
    final startTime = DateTime.now();

    try {
      // Set timeout for the connection
      _connect.timeout = const Duration(seconds: 30);

      Response? response;
      // Replace variables in URL, apply base URL, and build full URL
      final processedUrl = replaceVariables(url.value);
      final urlWithBase = buildUrlWithBase(processedUrl);
      final fullUrl = _buildFullUrl(urlWithBase);

      // Replace variables in headers
      final requestHeaders = <String, String>{};
      headers.forEach((key, value) {
        requestHeaders[replaceVariables(key)] = replaceVariables(value);
      });

      debugPrint('Sending ${httpMethod.value} request to: $fullUrl');

      // Wrap the request in a timeout
      response = await Future.any([
        _sendHttpRequest(fullUrl, requestHeaders),
        Future.delayed(
          const Duration(seconds: 30),
          () => throw Exception('Request timeout after 30 seconds'),
        ),
      ]);

      // Check if response is null
      if (response == null) {
        throw Exception('No response received from server');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;

      debugPrint('Response status: ${response.statusCode}');

      // Handle null response
      if (response.statusCode == null) {
        throw Exception('No response received from server');
      }

      final responseHeaders = <String, String>{};
      response.headers?.forEach((key, value) {
        responseHeaders[key] = value;
      });

      // Safely handle response body
      final responseBody = response.body ?? {};
      final bodySize = responseBody is String
          ? responseBody.length
          : jsonEncode(responseBody).length;

      currentResponse.value = HttpResponseModel(
        statusCode: response.statusCode!,
        statusMessage: response.statusText ?? 'OK',
        headers: responseHeaders,
        body: responseBody,
        size: bodySize,
        time: duration,
        timestamp: DateTime.now(),
      );

      // Save request after successful response
      saveCurrentRequest();

      final statusCode = response.statusCode!;
      final isSuccess = statusCode >= 200 && statusCode < 300;

      // Add to history
      addToHistory(
        HistoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          method: httpMethod.value,
          url: fullUrl,
          headers: Map<String, String>.from(requestHeaders),
          queryParams: Map<String, String>.from(queryParams),
          body: body.value.isNotEmpty ? body.value : null,
          statusCode: statusCode,
          statusMessage: response.statusText,
          responseTime: duration,
          responseSize: bodySize,
          timestamp: DateTime.now(),
          collectionId: selectedRequest.value?.id,
          requestName: selectedRequest.value?.name,
        ),
      );

      showNotification(
        'Request completed in ${duration}ms - Status: $statusCode',
        isSuccess ? 'success' : 'info',
      );
    } catch (e) {
      debugPrint('Error: $e');

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;

      // Create error response
      final errorMessage = e.toString();
      final errorBody = {
        'error': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      };

      currentResponse.value = HttpResponseModel(
        statusCode: 0,
        statusMessage: 'Request Failed',
        headers: {},
        body: errorBody,
        size: jsonEncode(errorBody).length,
        time: duration,
        timestamp: DateTime.now(),
      );

      // Show user-friendly error message
      String displayMessage = 'Request failed';
      if (errorMessage.contains('SocketException')) {
        displayMessage = 'Network error: Unable to connect to server';
      } else if (errorMessage.contains('TimeoutException')) {
        displayMessage = 'Request timeout: Server took too long to respond';
      } else if (errorMessage.contains('No response')) {
        displayMessage = 'No response received from server';
      } else {
        displayMessage = errorMessage.length > 100
            ? '${errorMessage.substring(0, 100)}...'
            : errorMessage;
      }

      showNotification(displayMessage, 'error');
    } finally {
      isLoading.value = false;
    }
  }

  String _buildFullUrl([String? baseUrl]) {
    final urlToUse = baseUrl ?? url.value;
    if (queryParams.isEmpty) return urlToUse;

    // Replace variables in query params
    final processedParams = <String, String>{};
    queryParams.forEach((key, value) {
      processedParams[replaceVariables(key)] = replaceVariables(value);
    });

    final uri = Uri.parse(urlToUse);
    final newUri = uri.replace(queryParameters: processedParams);
    return newUri.toString();
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
    body.value = request.body ?? '';

    // Sync headers list
    headersList.clear();
    request.headers.forEach((key, value) {
      headersList.add({'enabled': true, 'key': key, 'value': value});
    });
    if (headersList.isEmpty) {
      headersList.add({
        'enabled': true,
        'key': 'User-Agent',
        'value': 'HTTP API Ninja/1.0',
      });
    }
  }

  void saveCurrentRequest() {
    if (selectedRequest.value == null) return;

    final currentId = selectedRequest.value!.id;

    // Find collection and request
    for (var i = 0; i < collections.length; i++) {
      final requestIndex = collections[i].requests.indexWhere(
        (r) => r.id == currentId,
      );
      if (requestIndex != -1) {
        // Update request with current data
        final updatedRequest = collections[i].requests[requestIndex].copyWith(
          method: httpMethod.value,
          url: url.value,
          headers: Map<String, String>.from(headers),
          queryParams: Map<String, String>.from(queryParams),
          body: body.value.isEmpty ? null : body.value,
          lastUsed: DateTime.now(),
        );

        final updatedRequests = List<HttpRequestModel>.from(
          collections[i].requests,
        );
        updatedRequests[requestIndex] = updatedRequest;

        collections[i] = collections[i].copyWith(requests: updatedRequests);
        _saveCollections();
        break;
      }
    }
  }

  void toggleCollection(String collectionId) {
    final index = collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      collections[index] = collections[index].copyWith(
        isExpanded: !collections[index].isExpanded,
      );
      _saveCollections();
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
    _saveCollections();
  }

  void updateCollectionBaseUrl(String collectionId, String? baseUrl) {
    final index = collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      collections[index] = collections[index].copyWith(baseUrl: baseUrl);
      _saveCollections();
    }
  }

  /// Get the base URL for the collection that contains the selected request
  String? getSelectedRequestBaseUrl() {
    if (selectedRequest.value == null) return null;

    for (var collection in collections) {
      if (collection.requests.any((r) => r.id == selectedRequest.value!.id)) {
        return collection.baseUrl;
      }
    }
    return null;
  }

  /// Build full URL with collection base URL
  String buildUrlWithBase(String path) {
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
      _saveCollections();
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
      _saveCollections();
    }
  }

  void deleteCollection(String collectionId) {
    collections.removeWhere((c) => c.id == collectionId);
    _saveCollections();
  }

  void renameCollection(String collectionId, String newName) {
    final index = collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      collections[index] = collections[index].copyWith(name: newName);
      _saveCollections();
    }
  }

  // Headers management methods
  void addHeader() {
    headersList.add({'enabled': true, 'key': '', 'value': ''});
  }

  void removeHeader(int index) {
    headersList.removeAt(index);
    _syncHeadersToMap();
  }

  void toggleHeader(int index) {
    headersList[index]['enabled'] = !headersList[index]['enabled'];
    headersList.refresh();
    _syncHeadersToMap();
  }

  void updateHeaderKey(int index, String key) {
    headersList[index]['key'] = key;
    _syncHeadersToMap();
  }

  void updateHeaderValue(int index, String value) {
    headersList[index]['value'] = value;
    _syncHeadersToMap();
  }

  void _syncHeadersToMap() {
    headers.clear();
    for (var header in headersList) {
      if (header['enabled'] == true && header['key'].toString().isNotEmpty) {
        headers[header['key']] = header['value'];
      }
    }
  }

  // Query params management methods
  void addQueryParam() {
    final key = 'param${queryParams.length + 1}';
    queryParams[key] = '';
  }

  void removeQueryParam(String key) {
    queryParams.remove(key);
  }

  void updateQueryParam(String oldKey, String newKey, String value) {
    queryParams.remove(oldKey);
    queryParams[newKey] = value;
  }

  // Form data management methods
  void addFormData() {
    formDataList.add({'enabled': true, 'key': '', 'value': '', 'type': 'text'});
  }

  void removeFormData(int index) {
    formDataList.removeAt(index);
  }

  void toggleFormData(int index) {
    formDataList[index]['enabled'] = !formDataList[index]['enabled'];
    formDataList.refresh();
  }

  void updateFormDataKey(int index, String key) {
    formDataList[index]['key'] = key;
  }

  void updateFormDataValue(int index, String value) {
    formDataList[index]['value'] = value;
  }

  void updateFormDataType(int index, String type) {
    formDataList[index]['type'] = type;
    formDataList.refresh();
  }

  // Tests management methods
  void addTest() {
    testsList.add({
      'condition': 'Status Code',
      'operator': 'equals',
      'value': '200',
    });
  }

  void removeTest(int index) {
    testsList.removeAt(index);
  }

  void updateTestCondition(int index, String condition) {
    testsList[index]['condition'] = condition;
  }

  void updateTestOperator(int index, String operator) {
    testsList[index]['operator'] = operator;
  }

  void updateTestValue(int index, String value) {
    testsList[index]['value'] = value;
  }

  // Code snippet language selection
  final RxString selectedCodeLanguage = 'Dart'.obs;

  // Resizable panel width
  final RxDouble responseAreaWidth = 400.0.obs;

  // Helper method to send HTTP request
  Future<Response> _sendHttpRequest(
    String fullUrl,
    Map<String, String> requestHeaders,
  ) async {
    // Prepare body data based on body type
    dynamic bodyData;

    debugPrint('Body type: ${bodyType.value}');
    debugPrint('Body value: "${body.value}"');
    debugPrint('Body isEmpty: ${body.value.isEmpty}');

    if (body.value.isNotEmpty && bodyType.value != 'None') {
      switch (bodyType.value) {
        case 'JSON':
          try {
            bodyData = jsonDecode(body.value);
            // Add Content-Type header for JSON
            requestHeaders['Content-Type'] = 'application/json';
            debugPrint('Parsed JSON body: $bodyData');
          } catch (e) {
            debugPrint('JSON parse error: $e');
            // If JSON parsing fails, send as raw string
            bodyData = body.value;
            requestHeaders['Content-Type'] = 'application/json';
          }
          break;
        case 'XML':
          bodyData = body.value;
          requestHeaders['Content-Type'] = 'application/xml';
          break;
        case 'Text':
          bodyData = body.value;
          requestHeaders['Content-Type'] = 'text/plain';
          break;
        case 'Form Data':
          // Build form data from formDataList
          final formMap = <String, dynamic>{};
          for (var field in formDataList) {
            if (field['enabled'] == true &&
                field['key'].toString().isNotEmpty) {
              formMap[field['key']] = field['value'];
            }
          }
          bodyData = formMap;
          requestHeaders['Content-Type'] = 'application/x-www-form-urlencoded';
          break;
        default:
          bodyData = body.value.isNotEmpty ? body.value : null;
      }
    }

    debugPrint('Final bodyData: $bodyData');
    debugPrint('Final headers: $requestHeaders');

    switch (httpMethod.value) {
      case 'GET':
        return await _connect.get(fullUrl, headers: requestHeaders);
      case 'POST':
        return await _connect.post(fullUrl, bodyData, headers: requestHeaders);
      case 'PUT':
        return await _connect.put(fullUrl, bodyData, headers: requestHeaders);
      case 'DELETE':
        return await _connect.delete(fullUrl, headers: requestHeaders);
      case 'PATCH':
        return await _connect.patch(fullUrl, bodyData, headers: requestHeaders);
      case 'HEAD':
        return await _connect.get(fullUrl, headers: requestHeaders);
      case 'OPTIONS':
        return await _connect.get(fullUrl, headers: requestHeaders);
      default:
        return await _connect.get(fullUrl, headers: requestHeaders);
    }
  }
}
