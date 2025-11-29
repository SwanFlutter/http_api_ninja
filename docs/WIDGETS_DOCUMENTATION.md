# HTTP API Ninja - Widgets & Views Documentation

Complete documentation of all UI components, widgets, and views in the HTTP API Ninja application.

---

## 📋 Table of Contents

1. [Views](#views)
2. [Main Widgets](#main-widgets)
3. [Tab Widgets](#tab-widgets)
4. [Dialog Widgets](#dialog-widgets)
5. [Utility Widgets](#utility-widgets)

---

## Views

### HomeView
**File:** `lib/views/home_view.dart`

**Description:** Main application view that serves as the root layout container.

#### Structure

```
HomeView
├── SidebarWidget (280px fixed width)
├── RequestBuilderWidget (flexible)
├── Resizer (4px)
├── ResponseAreaWidget (resizable)
└── Notification Banner (overlay)
```

#### Key Features

- Three-column layout with resizable panels
- Notification banner at bottom
- Responsive design with drag-to-resize functionality
- Real-time status updates

#### Methods

```dart
/// Build main application layout
@override
Widget build(BuildContext context)
```

---

## Main Widgets

### SidebarWidget
**File:** `lib/widgets/sidebar_widget.dart`

**Description:** Left sidebar containing collections, requests, and navigation tabs.

#### Structure

```
SidebarWidget
├── Action Buttons
│   ├── New Request Button
│   └── New Collection Button
├── Tab Navigation
│   ├── Activity Tab
│   ├── Collections Tab
│   └── Environment Tab
└── Tab Content
    ├── Collections List
    ├── History List
    └── Environment Manager
```

#### Key Features

- Collections management
- Request history
- Environment variables
- Tab-based navigation
- Context menus for collections/requests

#### Methods

```dart
/// Show new collection dialog
void _showNewCollectionDialog(
  BuildContext context,
  HttpController controller,
)

/// Show new request dialog
void _showNewRequestDialog(
  BuildContext context,
  HttpController controller,
)

/// Show delete collection confirmation
void _showDeleteCollectionDialog(
  BuildContext context,
  HttpController controller,
  String collectionId,
)

/// Show rename collection dialog
void _showRenameCollectionDialog(
  BuildContext context,
  HttpController controller,
  String collectionId,
  String currentName,
)

/// Show delete request confirmation
void _showDeleteRequestDialog(
  BuildContext context,
  HttpController controller,
  String collectionId,
  String requestId,
)

/// Show rename request dialog
void _showRenameRequestDialog(
  BuildContext context,
  HttpController controller,
  String collectionId,
  String requestId,
  String currentName,
)

/// Build collections list
Widget _buildCollectionsList(
  BuildContext context,
  HttpController controller,
)

/// Build history list
Widget _buildHistoryList(
  BuildContext context,
  HttpController controller,
)

/// Build environment tab
Widget _buildEnvironmentTab(
  BuildContext context,
  HttpController controller,
)
```

---

### RequestBuilderWidget
**File:** `lib/widgets/request_builder_widget.dart`

**Description:** Central widget for building and configuring HTTP requests.

#### Structure

```
RequestBuilderWidget
├── URL Bar
│   ├── Method Dropdown
│   ├── URL TextField
│   └── Send Button
├── Tab Navigation
│   ├── Query Tab
│   ├── Headers Tab
│   ├── Body Tab
│   ├── Auth Tab
│   ├── Pre-run Tab
│   └── Tests Tab
└── Tab Content (dynamic)
```

#### Key Features

- HTTP method selection
- URL input with variable support
- Multiple request configuration tabs
- Real-time request building
- Send button with loading state

#### Methods

```dart
/// Build main request builder layout
@override
Widget build(BuildContext context)

/// Build URL bar with method and URL input
Widget _buildUrlBar(BuildContext context)

/// Build tab navigation
Widget _buildTabNavigation(BuildContext context)

/// Build tab content based on selected tab
Widget _buildTabContent(BuildContext context)

/// Handle send request
void _sendRequest(HttpController controller)
```

---

### ResponseAreaWidget
**File:** `lib/widgets/response_area_widget.dart`

**Description:** Right panel displaying HTTP response data.

#### Structure

```
ResponseAreaWidget
├── Response Header
│   ├── Status Code
│   ├── Response Time
│   └── Response Size
├── Tab Navigation
│   ├── Response Tab
│   ├── Headers Tab
│   ├── Code Snippet Tab
│   └── Terminal Tab
└── Tab Content (dynamic)
```

#### Key Features

- Response status display
- Response headers viewer
- Code snippet generation
- Terminal output
- Pretty JSON formatting
- Response size and timing metrics

#### Methods

```dart
/// Build response area layout
@override
Widget build(BuildContext context)

/// Build response header with metadata
Widget _buildResponseHeader(BuildContext context)

/// Build response body viewer
Widget _buildResponseBody(BuildContext context)

/// Build response headers viewer
Widget _buildResponseHeaders(BuildContext context)

/// Build code snippet generator
Widget _buildCodeSnippet(BuildContext context)

/// Format JSON response for display
String _formatJson(dynamic json)

/// Copy response to clipboard
void _copyToClipboard(String text)
```

---

### WelcomeScreenWidget
**File:** `lib/widgets/welcome_screen_widget.dart`

**Description:** Welcome screen shown when no request is selected.

#### Features

- Welcome message
- Quick start guide
- Create new collection button
- Create new request button
- Feature highlights

#### Methods

```dart
/// Build welcome screen
@override
Widget build(BuildContext context)
```

---

## Tab Widgets

### QueryTab
**File:** `lib/widgets/tabs/query_tab.dart`

**Description:** Tab for managing URL query parameters.

#### Features

- Add/remove query parameters
- Edit parameter key and value
- Enable/disable parameters
- Real-time URL preview

#### Methods

```dart
/// Build query parameters list
@override
Widget build(BuildContext context)

/// Build query parameter item
Widget _buildQueryParamItem(
  BuildContext context,
  int index,
  Map<String, dynamic> param,
)

/// Add new query parameter
void _addQueryParam(HttpController controller)

/// Remove query parameter
void _removeQueryParam(HttpController controller, int index)

/// Update query parameter
void _updateQueryParam(
  HttpController controller,
  int index,
  String key,
  String value,
)
```

---

### HeadersTab
**File:** `lib/widgets/tabs/headers_tab.dart`

**Description:** Tab for managing HTTP request headers.

#### Features

- Add/remove headers
- Edit header key and value
- Enable/disable headers
- Common headers presets
- Header validation

#### Methods

```dart
/// Build headers list
@override
Widget build(BuildContext context)

/// Build header item
Widget _buildHeaderItem(
  BuildContext context,
  int index,
  Map<String, dynamic> header,
)

/// Add new header
void _addHeader(HttpController controller)

/// Remove header
void _removeHeader(HttpController controller, int index)

/// Toggle header enabled state
void _toggleHeader(HttpController controller, int index)

/// Update header key
void _updateHeaderKey(HttpController controller, int index, String key)

/// Update header value
void _updateHeaderValue(HttpController controller, int index, String value)

/// Show common headers menu
void _showCommonHeadersMenu(BuildContext context, HttpController controller)
```

---

### BodyTab
**File:** `lib/widgets/tabs/body_tab.dart`

**Description:** Tab for managing request body.

#### Features

- Body type selection (JSON, XML, Text, Form Data)
- Body editor with syntax highlighting
- Form data builder
- JSON validation
- Pretty print formatting

#### Methods

```dart
/// Build body editor
@override
Widget build(BuildContext context)

/// Build body type selector
Widget _buildBodyTypeSelector(BuildContext context)

/// Build body editor based on type
Widget _buildBodyEditor(BuildContext context)

/// Build form data editor
Widget _buildFormDataEditor(BuildContext context)

/// Validate JSON
bool _validateJson(String json)

/// Format JSON
String _formatJson(String json)

/// Add form data field
void _addFormDataField(HttpController controller)

/// Remove form data field
void _removeFormDataField(HttpController controller, int index)
```

---

### AuthTab
**File:** `lib/widgets/tabs/auth_tab.dart`

**Description:** Tab for managing authentication.

#### Features

- Authentication type selection (None, Basic, Bearer, API Key)
- Credentials input
- Token management
- Auto-header generation

#### Methods

```dart
/// Build authentication selector
@override
Widget build(BuildContext context)

/// Build basic auth form
Widget _buildBasicAuth(BuildContext context)

/// Build bearer token form
Widget _buildBearerAuth(BuildContext context)

/// Build API key form
Widget _buildApiKeyAuth(BuildContext context)

/// Apply authentication to headers
void _applyAuth(HttpController controller)

/// Clear authentication
void _clearAuth(HttpController controller)
```

---

### PrerunTab
**File:** `lib/widgets/tabs/prerun_tab.dart`

**Description:** Tab for pre-request scripts.

#### Features

- Script editor
- Variable setup
- Request modification
- Syntax highlighting

#### Methods

```dart
/// Build pre-run script editor
@override
Widget build(BuildContext context)

/// Execute pre-run script
void _executePrerunScript(HttpController controller)

/// Validate script syntax
bool _validateScript(String script)
```

---

### TestsTab
**File:** `lib/widgets/tabs/tests_tab.dart`

**Description:** Tab for managing response tests.

#### Features

- Test case creation
- Condition selection
- Operator selection
- Test execution
- Test results display

#### Methods

```dart
/// Build tests list
@override
Widget build(BuildContext context)

/// Build test item
Widget _buildTestItem(
  BuildContext context,
  int index,
  Map<String, dynamic> test,
)

/// Add new test
void _addTest(HttpController controller)

/// Remove test
void _removeTest(HttpController controller, int index)

/// Run tests
void _runTests(HttpController controller)

/// Display test results
void _showTestResults(List<Map<String, dynamic>> results)
```

---

## Dialog Widgets

### SettingsDialog
**File:** `lib/widgets/settings_dialog.dart`

**Description:** Settings dialog for application configuration.

#### Features

- Theme selection (Light, Dark, System)
- Language selection
- Application preferences
- About information

#### Methods

```dart
/// Show settings dialog
static void show(BuildContext context)

/// Build settings dialog content
Widget _buildSettingsContent(BuildContext context)

/// Build theme selector
Widget _buildThemeSelector(BuildContext context)

/// Build language selector
Widget _buildLanguageSelector(BuildContext context)

/// Build about section
Widget _buildAboutSection(BuildContext context)
```

---

### EnvironmentTab
**File:** `lib/widgets/environment_tab.dart`

**Description:** Tab for managing environments and variables.

#### Features

- Environment creation/deletion
- Variable management
- Active environment selection
- Environment import/export
- Global variables

#### Methods

```dart
/// Build environment manager
@override
Widget build(BuildContext context)

/// Build environments list
Widget _buildEnvironmentsList(BuildContext context)

/// Build variables editor
Widget _buildVariablesEditor(BuildContext context)

/// Add new environment
void _addEnvironment(HttpController controller)

/// Delete environment
void _deleteEnvironment(HttpController controller, String envId)

/// Add environment variable
void _addVariable(HttpController controller, String envId)

/// Remove environment variable
void _removeVariable(HttpController controller, String envId, String key)

/// Export environment
void _exportEnvironment(HttpController controller, String envId)

/// Import environment
void _importEnvironment(HttpController controller)
```

---

### HistoryTab
**File:** `lib/widgets/history_tab.dart`

**Description:** Tab for viewing and managing request history.

#### Features

- History list with search
- Filter by HTTP method
- Load from history
- Delete history items
- Clear history

#### Methods

```dart
/// Build history list
@override
Widget build(BuildContext context)

/// Build history item
Widget _buildHistoryItem(
  BuildContext context,
  HistoryModel item,
)

/// Build search and filter bar
Widget _buildSearchBar(BuildContext context)

/// Load history item
void _loadFromHistory(HttpController controller, HistoryModel item)

/// Delete history item
void _deleteHistoryItem(HttpController controller, String itemId)

/// Clear all history
void _clearAllHistory(HttpController controller)

/// Filter history by method
void _filterByMethod(HttpController controller, String method)

/// Search history
void _searchHistory(HttpController controller, String query)
```

---

## Utility Widgets

### UpdateButtonWidget
**File:** `lib/widgets/update_button_widget.dart`

**Description:** Button widget for checking and downloading updates.

#### Features

- Check for updates
- Download progress indicator
- Update notification
- Release notes display

#### Methods

```dart
/// Build update button
@override
Widget build(BuildContext context)

/// Check for updates
void _checkForUpdates(UpdateController controller)

/// Show update dialog
void _showUpdateDialog(BuildContext context, UpdateController controller)

/// Download update
void _downloadUpdate(UpdateController controller)
```

---

### TerminalWidget
**File:** `lib/widgets/terminal_widget.dart`

**Description:** Terminal widget for displaying logs and output.

#### Features

- Log display
- Log filtering
- Log clearing
- Syntax highlighting
- Auto-scroll

#### Methods

```dart
/// Build terminal widget
@override
Widget build(BuildContext context)

/// Build log list
Widget _buildLogList(BuildContext context)

/// Add log entry
void _addLog(String message, String level)

/// Clear logs
void _clearLogs()

/// Filter logs by level
void _filterLogs(String level)

/// Export logs
void _exportLogs()
```

---

## Widget Hierarchy

```
MaterialApp
└── HomeView
    ├── SidebarWidget
    │   ├── New Request Button
    │   ├── New Collection Button
    │   ├── Tab Navigation
    │   ├── CollectionsList
    │   ├── HistoryTab
    │   └── EnvironmentTab
    ├── RequestBuilderWidget
    │   ├── URL Bar
    │   ├── Tab Navigation
    │   ├── QueryTab
    │   ├── HeadersTab
    │   ├── BodyTab
    │   ├── AuthTab
    │   ├── PrerunTab
    │   └── TestsTab
    ├── Resizer
    ├── ResponseAreaWidget
    │   ├── Response Header
    │   ├── Tab Navigation
    │   ├── Response Body
    │   ├── Headers Viewer
    │   ├── Code Snippet
    │   └── Terminal
    └── Notification Banner
```

---

## Common Patterns

### Dialog Creation

```dart
void _showDialog(BuildContext context, String title, Widget content) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: context.textTheme.titleMedium,
      ),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: context.textTheme.labelMedium,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Action
            Get.back();
          },
          child: Text(
            'Confirm',
            style: context.textTheme.labelMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
```

### Reactive UI Update

```dart
Obx(() => Text(
  controller.selectedRequest.value?.name ?? 'No Request',
  style: context.textTheme.bodyMedium,
))
```

### List Building

```dart
Obx(() => ListView.builder(
  itemCount: controller.collections.length,
  itemBuilder: (context, index) {
    final collection = controller.collections[index];
    return ListTile(
      title: Text(collection.name),
      onTap: () => controller.selectRequest(collection.requests.first),
    );
  },
))
```

---

## Styling Guidelines

- Use `context.textTheme` for consistent typography
- Use `Theme.of(context)` for colors and theme data
- Use `Get.isDarkMode` for dark mode detection
- Use `Obx()` for reactive updates
- Use `const` for immutable widgets
- Use `EdgeInsets` for consistent spacing

---

## Notes

- All widgets use GetX for state management
- Responsive design adapts to different screen sizes
- Dark mode support throughout
- Internationalization support for all text
- Accessibility considerations for all interactive elements

