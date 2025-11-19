import 'dart:convert';

import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';

import '../models/collection_model.dart';
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

  @override
  void onInit() {
    super.onInit();
    _loadCollections();
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
      final fullUrl = _buildFullUrl();
      final requestHeaders = Map<String, String>.from(headers);

      print('Sending ${httpMethod.value} request to: $fullUrl');

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

      print('Response status: ${response.statusCode}');

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

      showNotification(
        'Request completed in ${duration}ms - Status: $statusCode',
        isSuccess ? 'success' : 'info',
      );
    } catch (e) {
      print('Error: $e');

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

  String _buildFullUrl() {
    if (queryParams.isEmpty) return url.value;
    final uri = Uri.parse(url.value);
    final newUri = uri.replace(queryParameters: queryParams);
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

  void addCollection(String name) {
    final collection = CollectionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      requests: [],
    );
    collections.add(collection);
    _saveCollections();
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
    switch (httpMethod.value) {
      case 'GET':
        return await _connect.get(fullUrl, headers: requestHeaders);
      case 'POST':
        final bodyData = body.value.isNotEmpty ? body.value : null;
        return await _connect.post(fullUrl, bodyData, headers: requestHeaders);
      case 'PUT':
        final bodyData = body.value.isNotEmpty ? body.value : null;
        return await _connect.put(fullUrl, bodyData, headers: requestHeaders);
      case 'DELETE':
        return await _connect.delete(fullUrl, headers: requestHeaders);
      case 'PATCH':
        final bodyData = body.value.isNotEmpty ? body.value : null;
        return await _connect.patch(fullUrl, bodyData, headers: requestHeaders);
      default:
        return await _connect.get(fullUrl, headers: requestHeaders);
    }
  }
}
