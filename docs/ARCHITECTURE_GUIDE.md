# HTTP API Ninja - Architecture & Best Practices Guide

Complete guide to the application architecture, design patterns, and best practices used in HTTP API Ninja.

---

## 📋 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Project Structure](#project-structure)
3. [Design Patterns](#design-patterns)
4. [State Management](#state-management)
5. [Data Flow](#data-flow)
6. [Best Practices](#best-practices)
7. [Development Guidelines](#development-guidelines)

---

## Architecture Overview

HTTP API Ninja follows a **Clean Architecture** pattern with **GetX** for state management and dependency injection.

### Architecture Layers

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Views, Widgets, UI Components)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Business Logic Layer           │
│  (Controllers, State Management)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Data Layer                  │
│  (Models, Storage, API Calls)       │
└─────────────────────────────────────┘
```

### Key Principles

- **Separation of Concerns:** Each layer has a specific responsibility
- **Dependency Injection:** Controllers are injected via GetX bindings
- **Reactive Programming:** GetX observables for reactive UI updates
- **Persistence:** Local storage for collections, history, and preferences
- **Error Handling:** Comprehensive error handling and user feedback

---

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── bindings/
│   └── http_ninja_bindings.dart      # GetX dependency injection
├── config/
│   └── constant.dart                 # Application constants
├── controller/
│   ├── http_controller.dart          # Main HTTP request controller
│   ├── theme_controller.dart         # Theme management
│   ├── locale_controller.dart        # Localization management
│   └── update_controller.dart        # Update checking
├── I18n/
│   ├── messages.dart                 # Base messages interface
│   ├── en.dart                       # English translations
│   ├── fa.dart                       # Persian translations
│   ├── ar.dart                       # Arabic translations
│   ├── de.dart                       # German translations
│   └── fr.dart                       # French translations
├── models/
│   ├── http_request_model.dart       # HTTP request model
│   ├── collection_model.dart         # Collection model
│   ├── http_response_model.dart      # HTTP response model
│   ├── environment_model.dart        # Environment model
│   ├── global_variables_model.dart   # Global variables model
│   ├── history_model.dart            # History model
│   └── ...                           # Other models
├── theme/
│   └── theme.dart                    # Application theme
├── views/
│   └── home_view.dart                # Main application view
└── widgets/
    ├── sidebar_widget.dart           # Left sidebar
    ├── request_builder_widget.dart   # Request builder
    ├── response_area_widget.dart     # Response display
    ├── welcome_screen_widget.dart    # Welcome screen
    ├── settings_dialog.dart          # Settings dialog
    ├── environment_tab.dart          # Environment manager
    ├── history_tab.dart              # History viewer
    ├── terminal_widget.dart          # Terminal output
    ├── update_button_widget.dart     # Update checker
    ├── tabs/
    │   ├── query_tab.dart            # Query parameters
    │   ├── headers_tab.dart          # Headers management
    │   ├── body_tab.dart             # Body editor
    │   ├── auth_tab.dart             # Authentication
    │   ├── prerun_tab.dart           # Pre-run scripts
    │   └── tests_tab.dart            # Tests management
    └── response/
        └── response_code_snippet_tab.dart  # Code snippets
```

---

## Design Patterns

### 1. MVC (Model-View-Controller)

- **Model:** Data classes (HttpRequestModel, CollectionModel, etc.)
- **View:** UI widgets (HomeView, SidebarWidget, etc.)
- **Controller:** Business logic (HttpController, ThemeController, etc.)

### 2. Repository Pattern

Controllers act as repositories, managing data access and persistence:

```dart
class HttpController extends GetXController {
  // Data access methods
  void _loadCollections() { }
  void _saveCollections() { }
  void _loadEnvironments() { }
  void _saveEnvironments() { }
}
```

### 3. Observer Pattern

GetX observables implement the observer pattern for reactive updates:

```dart
final RxList<CollectionModel> collections = <CollectionModel>[].obs;

// Observers automatically update when collections change
Obx(() => ListView(
  children: controller.collections.map((c) => Text(c.name)).toList(),
))
```

### 4. Singleton Pattern

GetX controllers are singletons:

```dart
final controller = Get.find<HttpController>();
// Always returns the same instance
```

### 5. Factory Pattern

Models use factory constructors for JSON deserialization:

```dart
factory HttpRequestModel.fromJson(Map<String, dynamic> json) =>
    HttpRequestModel(
      id: json['id'],
      name: json['name'],
      // ...
    );
```

### 6. Builder Pattern

Models use copyWith for immutable updates:

```dart
final updatedRequest = request.copyWith(
  method: 'POST',
  url: 'https://api.example.com/users',
);
```

---

## State Management

### GetX Observables

GetX provides reactive state management through observables:

```dart
// Simple observable
final RxString url = ''.obs;

// List observable
final RxList<CollectionModel> collections = <CollectionModel>[].obs;

// Map observable
final RxMap<String, String> headers = <String, String>{}.obs;

// Custom observable
final Rx<HttpResponseModel?> currentResponse = Rx<HttpResponseModel?>(null);
```

### Reactive Updates

Widgets automatically rebuild when observables change:

```dart
Obx(() => Text(controller.url.value))
// Rebuilds whenever controller.url changes
```

### State Persistence

GetXStorage handles local persistence:

```dart
final storage = GetXStorage();

// Save data
storage.write(key: 'collections', value: data);

// Load data
final data = storage.read(key: 'collections');
```

---

## Data Flow

### Request Sending Flow

```
User Input
    ↓
RequestBuilderWidget
    ↓
HttpController.sendRequest()
    ↓
Variable Replacement (replaceVariables)
    ↓
Build Full URL (_buildFullUrl)
    ↓
GetConnect HTTP Request (_sendHttpRequest)
    ↓
Response Processing
    ↓
Save to History (addToHistory)
    ↓
Update UI (currentResponse.value)
    ↓
Show Notification (showNotification)
```

### Collection Management Flow

```
User Action (New Collection)
    ↓
SidebarWidget Dialog
    ↓
HttpController.addCollection()
    ↓
Create CollectionModel
    ↓
Add to collections list
    ↓
Save to Storage (_saveCollections)
    ↓
UI Updates (Obx)
```

### Environment Variable Flow

```
User Sets Variable
    ↓
EnvironmentTab
    ↓
HttpController.addEnvironmentVariable()
    ↓
Update EnvironmentModel
    ↓
Save to Storage (_saveEnvironments)
    ↓
User Sends Request
    ↓
replaceVariables() replaces {{var}} with value
    ↓
Request sent with actual values
```

---

## Best Practices

### 1. State Management

✅ **DO:**
```dart
// Use Obx for reactive updates
Obx(() => Text(controller.url.value))

// Use .obs for observables
final RxString url = ''.obs;

// Use copyWith for immutable updates
final updated = model.copyWith(name: 'New Name');
```

❌ **DON'T:**
```dart
// Don't modify state directly without .obs
controller.url = 'new url';

// Don't use setState in GetX
setState(() { });

// Don't create new instances unnecessarily
final newList = [...controller.collections];
```

### 2. Error Handling

✅ **DO:**
```dart
try {
  await controller.sendRequest();
} catch (e) {
  controller.showNotification('Error: $e', 'error');
  debugPrint('Error: $e');
}
```

❌ **DON'T:**
```dart
// Don't ignore errors
await controller.sendRequest();

// Don't show raw error messages to users
showDialog(context: context, builder: (_) => Text(e.toString()));
```

### 3. Performance

✅ **DO:**
```dart
// Use const constructors
const SizedBox(height: 16)

// Use Obx only when necessary
Obx(() => Text(controller.url.value))

// Use ListView.builder for large lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

❌ **DON'T:**
```dart
// Don't use non-const constructors
SizedBox(height: 16)

// Don't wrap entire widgets in Obx
Obx(() => Scaffold(
  body: Column(children: [...])
))

// Don't use ListView for large lists
ListView(children: items.map((i) => ItemWidget(i)).toList())
```

### 4. Code Organization

✅ **DO:**
```dart
// Group related methods
// HTTP Methods
Future<void> sendRequest() { }
String _buildFullUrl() { }

// Collection Methods
void addCollection(String name) { }
void deleteCollection(String id) { }

// Environment Methods
void addEnvironment(String name) { }
void setActiveEnvironment(String id) { }
```

❌ **DON'T:**
```dart
// Don't mix unrelated methods
void sendRequest() { }
void addCollection() { }
void setTheme() { }
void addEnvironment() { }
```

### 5. Naming Conventions

✅ **DO:**
```dart
// Use descriptive names
final RxString httpMethod = 'GET'.obs;
final RxList<CollectionModel> collections = <CollectionModel>[].obs;

void _showNewCollectionDialog() { }
void _buildUrlBar() { }
```

❌ **DON'T:**
```dart
// Don't use abbreviations
final RxString method = 'GET'.obs;
final RxList<CollectionModel> cols = <CollectionModel>[].obs;

void _show() { }
void _build() { }
```

### 6. Documentation

✅ **DO:**
```dart
/// Send HTTP request with current configuration
/// Handles timeouts, errors, and response processing
Future<void> sendRequest() async {
  // Implementation
}
```

❌ **DON'T:**
```dart
// Send request
void sendRequest() {
  // Implementation
}
```

---

## Development Guidelines

### Adding a New Feature

1. **Create Model** (if needed)
   ```dart
   class NewModel {
     final String id;
     final String name;
     
     NewModel({required this.id, required this.name});
     
     Map<String, dynamic> toJson() => {...};
     factory NewModel.fromJson(Map<String, dynamic> json) => ...;
     NewModel copyWith({String? id, String? name}) => ...;
   }
   ```

2. **Add to Controller**
   ```dart
   class HttpController extends GetXController {
     final RxList<NewModel> items = <NewModel>[].obs;
     
     void addItem(String name) {
       final item = NewModel(id: DateTime.now().toString(), name: name);
       items.add(item);
       _saveItems();
     }
   }
   ```

3. **Create Widget**
   ```dart
   class NewWidget extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<HttpController>();
       return Obx(() => ListView(
         children: controller.items.map((item) => Text(item.name)).toList(),
       ));
     }
   }
   ```

4. **Add to UI**
   ```dart
   // Add widget to appropriate view/widget
   ```

### Testing Guidelines

```dart
// Test model serialization
test('HttpRequestModel serialization', () {
  final model = HttpRequestModel(...);
  final json = model.toJson();
  final restored = HttpRequestModel.fromJson(json);
  expect(restored.id, model.id);
});

// Test controller methods
test('HttpController.addCollection', () {
  final controller = HttpController();
  controller.addCollection('Test');
  expect(controller.collections.length, 1);
  expect(controller.collections.first.name, 'Test');
});
```

### Performance Optimization

1. **Use const constructors**
   ```dart
   const SizedBox(height: 16)
   ```

2. **Use ListView.builder for large lists**
   ```dart
   ListView.builder(itemCount: items.length, itemBuilder: ...)
   ```

3. **Minimize Obx scope**
   ```dart
   // Good
   Obx(() => Text(controller.url.value))
   
   // Bad
   Obx(() => Scaffold(body: ...))
   ```

4. **Use GetConnect timeout**
   ```dart
   _connect.timeout = const Duration(seconds: 30);
   ```

---

## Common Patterns

### Dialog Pattern

```dart
void _showDialog(BuildContext context, String title, Widget content) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, style: context.textTheme.titleMedium),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel', style: context.textTheme.labelMedium),
        ),
        ElevatedButton(
          onPressed: () {
            // Action
            Get.back();
          },
          child: Text('Confirm', style: context.textTheme.labelMedium),
        ),
      ],
    ),
  );
}
```

### List Item Pattern

```dart
Widget _buildListItem(BuildContext context, int index, Model item) {
  return ListTile(
    title: Text(item.name, style: context.textTheme.bodyMedium),
    trailing: PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Edit'),
          onTap: () => _editItem(context, item),
        ),
        PopupMenuItem(
          child: Text('Delete'),
          onTap: () => _deleteItem(context, item.id),
        ),
      ],
    ),
  );
}
```

### Form Pattern

```dart
Widget _buildForm(BuildContext context, HttpController controller) {
  return Column(
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
  );
}
```

---

## Troubleshooting

### Issue: UI not updating

**Solution:** Ensure you're using `.obs` and `Obx()`:
```dart
final RxString url = ''.obs;  // Add .obs
Obx(() => Text(url.value))    // Wrap in Obx
```

### Issue: Data not persisting

**Solution:** Ensure you're calling save methods:
```dart
void addCollection(String name) {
  collections.add(CollectionModel(...));
  _saveCollections();  // Don't forget this
}
```

### Issue: Slow performance

**Solution:** Use ListView.builder and minimize Obx scope:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => Obx(() => Text(items[index].name)),
)
```

---

## Resources

- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

