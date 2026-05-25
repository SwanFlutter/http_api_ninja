import 'package:get_x_master/get_x_master.dart';

mixin RequestMixin {
  // Request builder fields
  final RxString httpMethod = 'GET'.obs;
  final RxString url = ''.obs;
  final RxMap<String, String> headers = <String, String>{}.obs;
  final RxMap<String, String> queryParams = <String, String>{}.obs;

  // Headers management
  final RxList<Map<String, dynamic>> headersList = <Map<String, dynamic>>[
    {'enabled': true, 'key': 'User-Agent', 'value': 'HTTP API Ninja/1.0'},
  ].obs;

  // Auth management
  final RxString authType = 'None'.obs;
  final RxString authUsername = ''.obs;
  final RxString authPassword = ''.obs;
  final RxString authToken = ''.obs;

  // Body management - separate storage for each body type
  final RxString bodyType = 'None'.obs;
  final RxString body = ''.obs;
  final RxString jsonBody = ''.obs;
  final RxString xmlBody = ''.obs;
  final RxString textBody = ''.obs;
  final RxString graphqlQuery = ''.obs;
  final RxString graphqlVariables = ''.obs;
  final RxList<Map<String, dynamic>> formDataList =
      <Map<String, dynamic>>[].obs;

  // Tests management
  final RxList<Map<String, dynamic>> testsList = <Map<String, dynamic>>[].obs;

  // Pre-run script
  final RxString preRunScript = ''.obs;

  /// Get the current body based on the selected bodyType
  String getRequestBody() {
    switch (bodyType.value) {
      case 'JSON':
        return jsonBody.value;
      case 'XML':
        return xmlBody.value;
      case 'Text':
        return textBody.value;
      case 'GraphQL':
        return graphqlQuery.value;
      case 'Form Data':
        return '';
      default:
        return '';
    }
  }

  /// Set body for the current body type and sync the general body variable
  void setBodyForType(String newBody) {
    body.value = newBody;
    switch (bodyType.value) {
      case 'JSON':
        jsonBody.value = newBody;
        break;
      case 'XML':
        xmlBody.value = newBody;
        break;
      case 'Text':
        textBody.value = newBody;
        break;
      case 'GraphQL':
        graphqlQuery.value = newBody;
        break;
    }
  }

  // Headers management methods
  void addHeader() {
    headersList.add({'enabled': true, 'key': '', 'value': ''});
  }

  void removeHeader(int index) {
    headersList.removeAt(index);
    syncHeadersToMap();
  }

  void toggleHeader(int index) {
    headersList[index]['enabled'] = !headersList[index]['enabled'];
    headersList.refresh();
    syncHeadersToMap();
  }

  void updateHeaderKey(int index, String key) {
    headersList[index]['key'] = key;
    syncHeadersToMap();
  }

  void updateHeaderValue(int index, String value) {
    headersList[index]['value'] = value;
    syncHeadersToMap();
  }

  void syncHeadersToMap() {
    headers.clear();
    for (var header in headersList) {
      if (header['enabled'] == true && header['key'].toString().isNotEmpty) {
        headers[header['key']] = header['value'];
      }
    }
  }

  void syncHeadersListFromMap() {
    headersList.clear();
    headers.forEach((key, value) {
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
}
