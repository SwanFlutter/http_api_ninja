# HTTP API Ninja - Quick Start Guide

Quick reference guide for developers to get started with HTTP API Ninja codebase.

---

## 📋 Quick Navigation

- **API Reference:** See `API_DOCUMENTATION.md`
- **UI Components:** See `WIDGETS_DOCUMENTATION.md`
- **Architecture:** See `ARCHITECTURE_GUIDE.md`

---

## Project Setup

### Prerequisites

```bash
# Install Flutter
flutter --version

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Project Structure

```
lib/
├── main.dart                 # Entry point
├── bindings/                 # Dependency injection
├── config/                   # Constants
├── controller/               # Business logic
├── I18n/                     # Translations
├── models/                   # Data models
├── theme/                    # UI theme
├── views/                    # Main views
└── widgets/                  # UI components
```

---

## Key Classes

### HttpController
Main controller for HTTP requests and collections.

```dart
final controller = Get.find<HttpController>();

// Send request
await controller.sendRequest();

// Manage collections
controller.addCollection('My API');
controller.addRequest(collectionId, request);

// Manage environments
controller.addEnvironment('Production');
controller.setActiveEnvironment(envId);

// Access history
final history = controller.filteredHistory;
```

### Models

```dart
// HTTP Request
HttpRequestModel(
  id: 'req1',
  name: 'Get Users',
  method: 'GET',
  url: 'https://api.example.com/users',
  createdAt: DateTime.now(),
)

// Collection
CollectionModel(
  id: 'col1',
  name: 'My API',
  requests: [request1, request2],
)

// Response
HttpResponseModel(
  statusCode: 200,
  statusMessage: 'OK',
  headers: {...},
  body: {...},
  size: 1024,
  time: 150,
  timestamp: DateTime.now(),
)
```

---

## Common Tasks

### Send HTTP Request

```dart
final controller = Get.find<HttpController>();

// Set request details
controller.httpMethod.value = 'POST';
controller.url.value = 'https://api.example.com/users';
controller.headers['Content-Type'] = 'application/json';
controller.body.value = '{"name": "John"}';

// Send
await controller.sendRequest();

// Access response
final response = controller.currentResponse.value;
print('Status: ${response?.statusCode}');
```

### Create Collection

```dart
final controller = Get.find<HttpController>();

// Add collection
controller.addCollection('My API');

// Add request
final request = HttpRequestModel(
  id: 'req1',
  name: 'Get Users',
  method: 'GET',
  url: 'https://api.example.com/users',
  createdAt: DateTime.now(),
);
controller.addRequest(collectionId, request);
```

### Use Environment Variables

```dart
final controller = Get.find<HttpController>();

// Add environment
controller.addEnvironment('Production');

// Add variable
controller.addEnvironmentVariable(
  envId,
  'base_url',
  'https://api.prod.com',
);

// Use in URL
controller.url.value = '{{base_url}}/users';

// Variables auto-replaced when sending
await controller.sendRequest();
```

### Manage Headers

```dart
final controller = Get.find<HttpController>();

// Add header
controller.addHeader();
controller.updateHeaderKey(0, 'Authorization');
controller.updateHeaderValue(0, 'Bearer token123');

// Toggle header
controller.toggleHeader(0);

// Remove header
controller.removeHeader(0);
```

### Access History

```dart
final controller = Get.find<HttpController>();

// Get filtered history
final history = controller.filteredHistory;

// Load from history
controller.loadFromHistory(history.first);

// Clear history
controller.clearHistory();

// Clear by method
controller.clearHistoryByMethod('GET');
```

---

## UI Components

### Main Views

```dart
// Home view - main application layout
HomeView()

// Contains:
// - SidebarWidget (left)
// - RequestBuilderWidget (center)
// - ResponseAreaWidget (right)
```

### Sidebar

```dart
// Collections list
// History tab
// Environment manager
// New request/collection buttons
```

### Request Builder

```dart
// URL bar with method selector
// Query parameters tab
// Headers tab
// Body editor tab
// Authentication tab
// Pre-run scripts tab
// Tests tab
```

### Response Area

```dart
// Response status and metadata
// Response body viewer
// Response headers viewer
// Code snippet generator
// Terminal output
```

---

## State Management

### Observables

```dart
// Simple observable
final RxString url = ''.obs;

// List observable
final RxList<CollectionModel> collections = <CollectionModel>[].obs;

// Map observable
final RxMap<String, String> headers = <String, String>{}.obs;

// Custom observable
final Rx<HttpResponseModel?> response = Rx<HttpResponseModel?>(null);
```

### Reactive Updates

```dart
// Automatically rebuilds when observable changes
Obx(() => Text(controller.url.value))

// Update observable
controller.url.value = 'https://api.example.com';
```

### Persistence

```dart
final storage = GetXStorage();

// Save
storage.write(key: 'collections', value: data);

// Load
final data = storage.read(key: 'collections');
```

---

## Theming

### Access Theme

```dart
// Get theme data
final theme = Theme.of(context);

// Get text theme
final textTheme = context.textTheme;

// Check dark mode
final isDark = Get.isDarkMode;
```

### Theme Controller

```dart
final themeController = Get.find<ThemeController>();

// Set theme
themeController.setLight();
themeController.setDark();
themeController.setSystem();

// Check current theme
final isDark = themeController.isDark;
```

---

## Localization

### Access Translations

```dart
// Use translation keys
Text(Messages.newRequest.tr)

// Supported languages
// - English (en_US)
// - Persian (fa_IR)
// - Arabic (ar_SA)
// - German (de_DE)
// - French (fr_FR)
```

### Change Language

```dart
final localeController = Get.find<LocaleController>();

// Change locale
localeController.changeLocale(const Locale('fa', 'IR'));
```

---

## Debugging

### Print Logs

```dart
debugPrint('Message: $value');
```

### Check Observable Values

```dart
print('URL: ${controller.url.value}');
print('Collections: ${controller.collections.length}');
```

### View Storage

```dart
final storage = GetXStorage();
final data = storage.read(key: 'collections');
print('Stored data: $data');
```

---

## Common Patterns

### Dialog

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Title', style: context.textTheme.titleMedium),
    content: Text('Content'),
    actions: [
      TextButton(
        onPressed: () => Get.back(),
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          // Action
          Get.back();
        },
        child: Text('Confirm'),
      ),
    ],
  ),
);
```

### List

```dart
Obx(() => ListView.builder(
  itemCount: controller.collections.length,
  itemBuilder: (context, index) {
    final item = controller.collections[index];
    return ListTile(
      title: Text(item.name),
      onTap: () => controller.selectRequest(item),
    );
  },
))
```

### Form

```dart
Column(
  children: [
    TextField(
      onChanged: (value) => controller.url.value = value,
      decoration: InputDecoration(labelText: 'URL'),
    ),
    SizedBox(height: 16),
    ElevatedButton(
      onPressed: () => controller.sendRequest(),
      child: Text('Send'),
    ),
  ],
)
```

---

## Tips & Tricks

### Performance

- Use `const` constructors
- Use `ListView.builder` for large lists
- Minimize `Obx` scope
- Use `GetConnect` timeout

### Code Quality

- Use descriptive names
- Add documentation comments
- Group related methods
- Handle errors properly

### Testing

- Test model serialization
- Test controller methods
- Test UI components
- Test state management

---

## Useful Links

- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design](https://material.io/design)

---

## Troubleshooting

### UI not updating?
- Ensure using `.obs` and `Obx()`
- Check if observable is being modified

### Data not persisting?
- Ensure calling save methods
- Check storage permissions

### Slow performance?
- Use `ListView.builder`
- Minimize `Obx` scope
- Use `const` constructors

### HTTP request failing?
- Check URL format
- Check network connectivity
- Check request timeout
- Check headers and body

---

## Next Steps

1. Read `API_DOCUMENTATION.md` for detailed API reference
2. Read `WIDGETS_DOCUMENTATION.md` for UI components
3. Read `ARCHITECTURE_GUIDE.md` for architecture details
4. Start building features!

