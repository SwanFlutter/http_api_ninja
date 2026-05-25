import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get_x_master/get_x_master.dart';

import '../models/history_model.dart';
import '../models/http_response_model.dart';
import '../widgets/global/custom_toast.dart';
import 'collection_mixin.dart';
import 'environment_mixin.dart';
import 'history_mixin.dart';
import 'request_mixin.dart';

class HttpController extends GetXController
    with EnvironmentMixin, HistoryMixin, CollectionMixin, RequestMixin {
  final GetConnect _connect = GetConnect();

  // Observable variables
  final Rx<HttpResponseModel?> currentResponse = Rx<HttpResponseModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedTab = 'activity'.obs;
  final RxString selectedRequestTab = 'Query'.obs;
  final RxString selectedResponseTab = 'Response'.obs;
  final RxBool showTerminal = true.obs;

  // Code snippet language selection
  final RxString selectedCodeLanguage = 'Dart'.obs;

  // Resizable panel widths
  final RxDouble sidebarWidth = 280.0.obs;
  final RxDouble responseAreaWidth = 400.0.obs;

  // Notification messages
  final RxString notificationMessage = ''.obs;
  final RxString notificationType = ''.obs; // 'success', 'error', 'info'

  @override
  void onInit() {
    super.onInit();
    loadCollections();
    loadEnvironments();
    loadHistory();
    initializeSampleData();
  }

  @override
  void showNotification(String message, String type) {
    switch (type) {
      case 'success':
        CustomToast.success(title: message);
        break;
      case 'error':
        CustomToast.error(title: message);
        break;
      case 'warning':
        CustomToast.warning(title: message);
        break;
      case 'info':
      default:
        CustomToast.info(title: message);
    }
  }

  /// Get color for HTTP method
  Color getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return const Color(0xFF2196F3); // Blue
      case 'POST':
        return const Color(0xFF4CAF50); // Green
      case 'PUT':
        return const Color(0xFFFF9800); // Orange
      case 'DELETE':
        return const Color(0xFFF44336); // Red
      case 'PATCH':
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
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

      final collectionOverrides = getCollectionVariableOverrides();
      final processedUrl = _resolveRequestUrl(collectionOverrides);
      final fullUrl = _buildFullUrl(processedUrl);

      // Replace variables in headers
      final requestHeaders = <String, String>{};
      headers.forEach((key, value) {
        requestHeaders[replaceVariables(key, overrides: collectionOverrides)] =
            replaceVariables(value, overrides: collectionOverrides);
      });

      // debugPrint('Sending ${httpMethod.value} request to: $fullUrl');

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

      // debugPrint('Response status: ${response.statusCode}');

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
          body: getRequestBody().isNotEmpty ? getRequestBody() : null,
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
      // debugPrint('Error: $e');

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

  /// Resolves {{variables}}, collection base URL, and optional env base URL.
  String _resolveRequestUrl(Map<String, String> collectionOverrides) {
    final raw = url.value.trim();
    final usesBaseTemplate = CollectionMixin.urlUsesBaseUrlTemplate(raw);

    // 1. Replace {{baseUrl}} etc. — collection base wins over environment
    var resolved = replaceVariables(raw, overrides: collectionOverrides);

    // 2. Prepend collection base for plain relative paths (/api/...)
    if (!resolved.contains('{{')) {
      resolved = buildUrlWithBase(resolved);
    }

    // 3. Env base only for relative paths that do NOT use {{baseUrl}} template
    if (!usesBaseTemplate &&
        !resolved.startsWith('http://') &&
        !resolved.startsWith('https://') &&
        !resolved.contains('{{')) {
      final globalBase = _resolveEnvironmentBaseUrl(collectionOverrides);
      if (globalBase != null) {
        final base = globalBase.endsWith('/')
            ? globalBase.substring(0, globalBase.length - 1)
            : globalBase;
        final endpoint =
            resolved.startsWith('/') ? resolved : '/$resolved';
        resolved = '$base$endpoint';
      }
    }

    return replaceVariables(resolved, overrides: collectionOverrides);
  }

  String? _resolveEnvironmentBaseUrl(Map<String, String> collectionOverrides) {
    for (final placeholder in ['{{base_url}}', '{{baseUrl}}']) {
      final value = replaceVariables(
        placeholder,
        overrides: collectionOverrides,
      );
      if (value != placeholder && value.isNotEmpty) return value;
    }
    return null;
  }

  String _buildFullUrl([String? baseUrl]) {
    final urlToUse = baseUrl ?? url.value;
    if (queryParams.isEmpty) return urlToUse;

    final collectionOverrides = getCollectionVariableOverrides();

    // Replace variables in query params
    final processedParams = <String, String>{};
    queryParams.forEach((key, value) {
      processedParams[replaceVariables(key, overrides: collectionOverrides)] =
          replaceVariables(value, overrides: collectionOverrides);
    });

    final uri = Uri.parse(urlToUse);
    final newUri = uri.replace(queryParameters: processedParams);
    return newUri.toString();
  }

  // Helper method to send HTTP request
  Future<Response> _sendHttpRequest(
    String fullUrl,
    Map<String, String> requestHeaders,
  ) async {
    // Prepare body data based on body type
    dynamic bodyData;
    final currentBody = getRequestBody();

    // debugPrint('Body type: ${bodyType.value}');
    // debugPrint('Body value: "$currentBody"');
    // debugPrint('Body isEmpty: ${currentBody.isEmpty}');

    final collectionOverrides = getCollectionVariableOverrides();

    if (currentBody.isNotEmpty && bodyType.value != 'None') {
      final processedBody = replaceVariables(
        currentBody,
        overrides: collectionOverrides,
      );
      switch (bodyType.value) {
        case 'JSON':
          try {
            final trimmedBody = processedBody.trim();
            if (trimmedBody.isEmpty) {
              bodyData = null;
            } else {
              bodyData = jsonDecode(trimmedBody);
            }
            requestHeaders['Content-Type'] = 'application/json';
            // debugPrint('Parsed JSON body: $bodyData');
          } catch (e) {
            // debugPrint('JSON parse error: $e');
            String errorMsg = e.toString();
            if (errorMsg.contains('FormatException:')) {
              errorMsg = errorMsg.split('FormatException:').last.trim();
            }
            throw Exception(
              'Invalid JSON format: $errorMsg\n\nTip: Click the "Format" button to fix basic JSON errors.',
            );
          }
          break;
        case 'XML':
          bodyData = processedBody;
          requestHeaders['Content-Type'] = 'application/xml';
          break;
        case 'Text':
          bodyData = processedBody;
          requestHeaders['Content-Type'] = 'text/plain';
          break;
        case 'Form Data':
          // Build form data from formDataList
          final formMap = <String, dynamic>{};
          for (var field in formDataList) {
            if (field['enabled'] == true &&
                field['key'].toString().isNotEmpty) {
              formMap[replaceVariables(
                field['key'],
                overrides: collectionOverrides,
              )] = replaceVariables(
                field['value'].toString(),
                overrides: collectionOverrides,
              );
            }
          }
          bodyData = formMap;
          requestHeaders['Content-Type'] = 'application/x-www-form-urlencoded';
          break;
        default:
          bodyData = processedBody.isNotEmpty ? processedBody : null;
      }
    }

    // debugPrint('Final bodyData: $bodyData');
    // debugPrint('Final headers: $requestHeaders');

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
