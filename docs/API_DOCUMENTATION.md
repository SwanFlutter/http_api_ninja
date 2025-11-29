# HTTP API Ninja - Complete API Documentation

Complete documentation of all classes, methods, and their functionality in the HTTP API Ninja application.

---

## 📋 Table of Contents

1. [Controllers](#controllers)
2. [Models](#models)
3. [Configuration](#configuration)

---

## Controllers

### HttpController
**File:** `lib/controller/http_controller.dart`

**Description:** Main controller for handling HTTP requests, collections, environment variables, and application state management.

#### Observable Properties

```dart
// Collections & Requests
final RxList<CollectionModel> collections = <CollectionModel>[].obs
final Rx<HttpRequestModel?> selectedRequest = Rx<HttpRequestModel?>(null)
final Rx<HttpResponseModel?> currentResponse = Rx<HttpResponseModel?>(null)

// Request Configuration
final RxString httpMethod = 'GET'.obs
final RxString url = ''.obs
final RxMap<String, String> headers = <String, String>{}.obs
final RxMap<String, String> queryParams = <String, String>{}.obs
final RxString body = ''.obs

// Headers Management
final RxList<Map<String, dynamic>> headersList = <Map<String, dynamic>>[].obs

// Authentication
final RxString authType = 'None'.obs
final RxString authUsername = ''.obs
final RxString authPassword = ''.obs
final RxString authToken = ''.obs

// Body Management
final RxString bodyType = 'None'.obs
final RxList<Map<String, dynamic>> formDataList = <Map<String, dynamic>>[].obs

// Tests Management
final RxList<Map<String, dynamic>> testsList = <Map<String, dynamic>>[].obs

// Pre-run Script
final RxString preRunScript = ''.obs

// Environment Variables
final RxList<EnvironmentModel> environments = <EnvironmentModel>[].obs
final Rx<EnvironmentModel?> activeEnvironment = Rx<EnvironmentModel?>(null)
final Rx<GlobalVariablesModel> globalVariables = GlobalVariablesModel().obs

// History
final RxList<HistoryModel> history = <HistoryModel>[].obs
final RxString historySearchQuery = ''.obs
final RxString historyFilterMethod = 'All'.obs

// UI State
final RxBool isLoading = false.obs
final RxString selectedTab = 'activity'.obs
final RxString selectedRequestTab = 'Query'.obs
final RxString selectedResponseTab = 'Response'.obs
final RxBool showTerminal = true.obs
final RxDouble responseAreaWidth = 400.0.obs
final RxString selectedCodeLanguage = 'Dart'.obs

// Notifications
final RxString notificationMessage = ''.obs
final RxString notificationType = ''.obs
```

#### Core Methods

##### HTTP Request Methods

```dart
/// Send HTTP request with current configuration
/// Handles timeouts, errors, and response processing
Future<void> sendRequest()

/// Build full URL with query parameters
/// Replaces variables in URL and query params
String _buildFullUrl([String? baseUrl])

/// Send HTTP request with specified method and headers
/// Supports GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS
Future<Response> _sendHttpRequest(
  String fullUrl,
  Map<String, String> requestHeaders,
)
```

##### Collection Management Methods

```dart
/// Add new collection with given name
void addCollection(String name)

/// Delete collection by ID
void deleteCollection(String collectionId)

/// Rename collection
void renameCollection(String collectionId, String newName)

/// Toggle collection expanded/collapsed state
void toggleCollection(String collectionId)

/// Add request to collection
void addRequest(String collectionId, HttpRequestModel request)

/// Delete request from collection
void deleteRequest(String collectionId, String requestId)

/// Select request and load its data
void selectRequest(HttpRequestModel request)

/// Save current request data
void saveCurrentRequest()
```

##### Headers Management Methods

```dart
/// Add new header entry
void addHeader()

/// Remove header at index
void removeHeader(int index)

/// Toggle header enabled/disabled state
void toggleHeader(int index)

/// Update header key at index
void updateHeaderKey(int index, String key)

/// Update header value at index
void updateHeaderValue(int index, String value)

/// Sync headers list to headers map
void _syncHeadersToMap()
```

##### Query Parameters Methods

```dart
/// Add new query parameter
void addQueryParam()

/// Remove query parameter by key
void removeQueryParam(String key)

/// Update query parameter
void updateQueryParam(String oldKey, String newKey, String value)
```

##### Form Data Methods

```dart
/// Add new form data field
void addFormData()

/// Remove form data field at index
void removeFormData(int index)

/// Toggle form data field enabled/disabled
void toggleFormData(int index)

/// Update form data field key
void updateFormDataKey(int index, String key)

/// Update form data field value
void updateFormDataValue(int index, String value)

/// Update form data field type (text, file, etc.)
void updateFormDataType(int index, String type)
```

##### Tests Management Methods

```dart
/// Add new test case
void addTest()

/// Remove test case at index
void removeTest(int index)

/// Update test condition
void updateTestCondition(int index, String condition)

/// Update test operator
void updateTestOperator(int index, String operator)

/// Update test value
void updateTestValue(int index, String value)
```

##### Environment Methods

```dart
/// Load environments from storage
void _loadEnvironments()

/// Initialize default environments (Dev, Staging, Prod)
void _initializeDefaultEnvironments()

/// Save environments to storage
void _saveEnvironments()

/// Add new environment
void addEnvironment(String name)

/// Delete environment by ID
void deleteEnvironment(String id)

/// Rename environment
void renameEnvironment(String id, String newName)

/// Set active environment
void setActiveEnvironment(String id)

/// Add variable to environment
void addEnvironmentVariable(String envId, String key, String value)

/// Update environment variable
void updateEnvironmentVariable(String envId, String oldKey, String newKey, String value)

/// Delete environment variable
void deleteEnvironmentVariable(String envId, String key)

/// Add global variable
void addGlobalVariable(String key, String value)

/// Update global variable
void updateGlobalVariable(String oldKey, String newKey, String value)

/// Delete global variable
void deleteGlobalVariable(String key)

/// Replace {{variable}} placeholders with actual values
String replaceVariables(String input)

/// Export environment to JSON string
String exportEnvironment(String envId)

/// Import environment from JSON string
void importEnvironment(String jsonString)
```

##### History Methods

```dart
/// Load history from storage
void _loadHistory()

/// Save history to storage
void _saveHistory()

/// Add request to history
void addToHistory(HistoryModel item)

/// Delete history item by ID
void deleteHistoryItem(String id)

/// Clear all history
void clearHistory()

/// Clear history by HTTP method
void clearHistoryByMethod(String method)

/// Clear history older than specified duration
void clearHistoryOlderThan(Duration duration)

/// Get filtered history based on search and method filter
List<HistoryModel> get filteredHistory

/// Load history item into request builder
void loadFromHistory(HistoryModel item)
```

##### Utility Methods

```dart
/// Show notification message
void showNotification(String message, String type)

/// Initialize sample data for first-time users
void _initializeSampleData()

/// Load collections from storage
void _loadCollections()

/// Save collections to storage
void _saveCollections()
```

---

### ThemeController
**File:** `lib/controller/theme_controller.dart`

**Description:** Manages application theme (dark/light/system mode) and persists user preferences.

#### Enum

```dart
enum AvailableTheme { light, dark, system }
```

#### Observable Properties

```dart
var appThemeMode = AvailableTheme.dark.obs
```

#### Methods

```dart
/// Load saved theme from storage and return ThemeMode
ThemeMode loadSavedTheme()

/// Set light theme
void setLight()

/// Set dark theme
void setDark()

/// Set system theme
void setSystem()

/// Set theme by ThemeMode
void setTheme(ThemeMode mode)

/// Check if dark mode is active
bool get isDark

/// Get current ThemeMode
ThemeMode get themeMode
```

---

### LocaleController
**File:** `lib/controller/locale_controller.dart`

**Description:** Handles application localization and language switching.

#### Observable Properties

```dart
final Rx<Locale> currentLocale = const Locale('en', 'US').obs
```

#### Supported Locales

```dart
final List<Map<String, dynamic>> supportedLocales = [
  {'code': 'en_US', 'name': 'English', 'locale': const Locale('en', 'US')},
  {'code': 'fa_IR', 'name': 'فارسی', 'locale': const Locale('fa', 'IR')},
  {'code': 'ar_SA', 'name': 'العربية', 'locale': const Locale('ar', 'SA')},
  {'code': 'de_DE', 'name': 'Deutsch', 'locale': const Locale('de', 'DE')},
  {'code': 'fr_FR', 'name': 'Français', 'locale': const Locale('fr', 'FR')},
]
```

#### Methods

```dart
/// Change application locale
void changeLocale(Locale locale)

/// Load saved locale from storage
void _loadLocale()
```

---

### UpdateController
**File:** `lib/controller/update_controller.dart`

**Description:** Manages application updates by checking GitHub releases and downloading new versions.

#### Constants

```dart
static const String currentVersion = '1.0.0'
static const String githubOwner = 'SwanFlutter'
static const String githubRepo = 'http_api_ninja'
```

#### Observable Properties

```dart
final RxBool isChecking = false.obs
final RxBool updateAvailable = false.obs
final RxString latestVersion = ''.obs
final RxString downloadUrl = ''.obs
final RxString releaseNotes = ''.obs
final RxDouble downloadProgress = 0.0.obs
final RxBool isDownloading = false.obs
```

#### Methods

```dart
/// Check GitHub releases for new version
Future<void> checkForUpdates()

/// Find appropriate download URL for current platform
String _findDownloadUrl(List assets)

/// Compare version strings (e.g., "1.2.3" vs "1.2.2")
bool _isNewerVersion(String latest, String current)

/// Open download URL in browser
Future<void> openDownloadPage()

/// Open GitHub releases page
Future<void> openReleasesPage()

/// Download update file
Future<void> downloadUpdate(HttpController httpController)
```

---

## Models

### HttpRequestModel
**File:** `lib/models/http_request_model.dart`

**Description:** Represents a single HTTP request with all its configuration.

#### Properties

```dart
final String id                              // Unique identifier
final String name                            // Request name
final String method                          // HTTP method (GET, POST, etc.)
final String url                             // Request URL
final Map<String, String> headers            // Request headers
final Map<String, String> queryParams        // Query parameters
final String? body                           // Request body
final String? authType                       // Authentication type
final Map<String, String>? authData          // Authentication data
final DateTime createdAt                     // Creation timestamp
final DateTime? lastUsed                     // Last used timestamp
```

#### Methods

```dart
/// Convert to JSON
Map<String, dynamic> toJson()

/// Create from JSON
factory HttpRequestModel.fromJson(Map<String, dynamic> json)

/// Create copy with optional field updates
HttpRequestModel copyWith({
  String? id,
  String? name,
  String? method,
  String? url,
  Map<String, String>? headers,
  Map<String, String>? queryParams,
  String? body,
  String? authType,
  Map<String, String>? authData,
  DateTime? createdAt,
  DateTime? lastUsed,
})
```

---

### CollectionModel
**File:** `lib/models/collection_model.dart`

**Description:** Represents a collection of HTTP requests.

#### Properties

```dart
final String id                              // Unique identifier
final String name                            // Collection name
final List<HttpRequestModel> requests        // List of requests
final bool isExpanded                        // Expanded/collapsed state
```

#### Methods

```dart
/// Convert to JSON
Map<String, dynamic> toJson()

/// Create from JSON
factory CollectionModel.fromJson(Map<String, dynamic> json)

/// Create copy with optional field updates
CollectionModel copyWith({
  String? id,
  String? name,
  List<HttpRequestModel>? requests,
  bool? isExpanded,
})
```

---

### HttpResponseModel
**File:** `lib/models/http_response_model.dart`

**Description:** Represents an HTTP response with metadata.

#### Properties

```dart
final int statusCode                         // HTTP status code
final String statusMessage                   // Status message
final Map<String, String> headers            // Response headers
final dynamic body                           // Response body
final int size                               // Response size in bytes
final int time                               // Response time in milliseconds
final DateTime timestamp                     // Response timestamp
```

#### Computed Properties

```dart
String get statusText                        // Formatted status (e.g., "200 OK")
String get sizeText                          // Formatted size (e.g., "1.23 KB")
String get timeText                          // Formatted time (e.g., "150 ms")
```

#### Methods

```dart
/// Convert to JSON
Map<String, dynamic> toJson()

/// Create from JSON
factory HttpResponseModel.fromJson(Map<String, dynamic> json)
```

---

### EnvironmentModel
**File:** `lib/models/environment_model.dart`

**Description:** Represents an environment with variables for different deployment stages.

#### Properties

```dart
final String id                              // Unique identifier
final String name                            // Environment name
final Map<String, String> variables          // Environment variables
final bool isActive                          // Active environment flag
final DateTime createdAt                     // Creation timestamp
final DateTime? updatedAt                    // Last update timestamp
```

#### Methods

```dart
/// Get variable value by key
String? getVariable(String key)

/// Convert to JSON
Map<String, dynamic> toJson()

/// Create from JSON
factory EnvironmentModel.fromJson(Map<String, dynamic> json)

/// Create copy with optional field updates
EnvironmentModel copyWith({
  String? id,
  String? name,
  Map<String, String>? variables,
  bool? isActive,
  DateTime? createdAt,
  DateTime? updatedAt,
})
```

---

### GlobalVariablesModel
**File:** `lib/models/global_variables_model.dart`

**Description:** Represents global variables accessible across all environments.

#### Properties

```dart
final Map<String, String> variables          // Global variables
final DateTime createdAt                     // Creation timestamp
final DateTime? updatedAt                    // Last update timestamp
```

#### Methods

```dart
/// Convert to JSON
Map<String, dynamic> toJson()

/// Create from JSON
factory GlobalVariablesModel.fromJson(Map<String, dynamic> json)

/// Create copy with optional field updates
GlobalVariablesModel copyWith({
  Map<String, String>? variables,
  DateTime? createdAt,
  DateTime? updatedAt,
})
```

---

### HistoryModel
**File:** `lib/models/history_model.dart`

**Description:** Represents a request in the history.

#### Properties

```dart
final String id                              // Unique identifier
final String method                          // HTTP method
final String url                             // Request URL
final Map<String, String> headers            // Request headers
final Map<String, String> queryParams        // Query parameters
final String? body                           // Request body
final int? statusCode                        // Response status code
final String? statusMessage                  // Response status message
final int responseTime                       // Response time in milliseconds
final int responseSize                       // Response size in bytes
final DateTime timestamp                     // Request timestamp
final String? collectionId                   // Associated collection ID
final String? requestName                    // Associated request name
```

#### Methods

```dart
/// Convert to JSON
Map<String, dynamic> toJson()

/// Create from JSON
factory HistoryModel.fromJson(Map<String, dynamic> json)
```

---

## Configuration

### Constants
**File:** `lib/config/constant.dart`

Contains application-wide constants and configuration values.

### Theme
**File:** `lib/theme/theme.dart`

Defines application theme including colors, typography, and component styles.

### Bindings
**File:** `lib/bindings/http_ninja_bindings.dart`

GetX bindings for dependency injection and controller initialization.

### Internationalization
**Files:** `lib/I18n/`

- `messages.dart` - Base messages interface
- `en.dart` - English translations
- `fa.dart` - Persian translations
- `ar.dart` - Arabic translations
- `de.dart` - German translations
- `fr.dart` - French translations

---

## Usage Examples

### Sending a Request

```dart
final controller = Get.find<HttpController>();

// Set request details
controller.httpMethod.value = 'POST';
controller.url.value = 'https://api.example.com/users';
controller.headers['Content-Type'] = 'application/json';
controller.body.value = '{"name": "John", "email": "john@example.com"}';

// Send request
await controller.sendRequest();

// Access response
final response = controller.currentResponse.value;
print('Status: ${response?.statusCode}');
print('Body: ${response?.body}');
```

### Managing Collections

```dart
final controller = Get.find<HttpController>();

// Add collection
controller.addCollection('My API');

// Add request to collection
final request = HttpRequestModel(
  id: 'req1',
  name: 'Get Users',
  method: 'GET',
  url: 'https://api.example.com/users',
  createdAt: DateTime.now(),
);
controller.addRequest('collection_id', request);

// Select request
controller.selectRequest(request);
```

### Using Environment Variables

```dart
final controller = Get.find<HttpController>();

// Add environment
controller.addEnvironment('Production');

// Add variable to environment
controller.addEnvironmentVariable('prod_env_id', 'base_url', 'https://api.prod.com');

// Set active environment
controller.setActiveEnvironment('prod_env_id');

// Use variable in URL
controller.url.value = '{{base_url}}/users';

// Variables are automatically replaced when sending request
await controller.sendRequest();
```

### Accessing History

```dart
final controller = Get.find<HttpController>();

// Get filtered history
final history = controller.filteredHistory;

// Load from history
controller.loadFromHistory(history.first);

// Clear history
controller.clearHistory();
```

---

## Notes

- All observable properties use GetX's reactive programming model
- Storage is handled through GetXStorage for persistence
- HTTP requests support variable replacement using `{{variable_name}}` syntax
- Responses are automatically saved to history
- Collections and requests are persisted to local storage
- Theme and locale preferences are saved and restored on app restart

