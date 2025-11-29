# HTTP API Ninja - Documentation

Complete documentation for the HTTP API Ninja application.

---

## 📚 Documentation Files

### 1. **QUICK_START.md** - Start Here! 🚀
Quick reference guide for developers to get started quickly.

**Contents:**
- Project setup
- Key classes overview
- Common tasks
- UI components
- State management basics
- Theming and localization
- Debugging tips
- Common patterns

**Best for:** New developers, quick reference

---

### 2. **API_DOCUMENTATION.md** - Complete API Reference
Comprehensive documentation of all classes, methods, and properties.

**Contents:**
- HttpController (main controller)
- ThemeController (theme management)
- LocaleController (localization)
- UpdateController (update checking)
- HttpRequestModel
- CollectionModel
- HttpResponseModel
- EnvironmentModel
- GlobalVariablesModel
- HistoryModel
- Configuration files
- Usage examples

**Best for:** API reference, implementation details

---

### 3. **WIDGETS_DOCUMENTATION.md** - UI Components Guide
Complete documentation of all widgets and views.

**Contents:**
- HomeView (main layout)
- SidebarWidget (collections sidebar)
- RequestBuilderWidget (request editor)
- ResponseAreaWidget (response viewer)
- WelcomeScreenWidget
- Tab widgets (Query, Headers, Body, Auth, Pre-run, Tests)
- Dialog widgets
- Utility widgets
- Widget hierarchy
- Common patterns
- Styling guidelines

**Best for:** UI development, component reference

---

### 4. **ARCHITECTURE_GUIDE.md** - Architecture & Best Practices
Detailed guide to application architecture and development best practices.

**Contents:**
- Architecture overview
- Project structure
- Design patterns (MVC, Repository, Observer, Singleton, Factory, Builder)
- State management with GetX
- Data flow diagrams
- Best practices
- Development guidelines
- Common patterns
- Troubleshooting
- Performance optimization

**Best for:** Architecture understanding, best practices, development guidelines

---

## 🎯 Quick Navigation

### By Role

**Frontend Developer:**
1. Start with `QUICK_START.md`
2. Read `WIDGETS_DOCUMENTATION.md`
3. Reference `API_DOCUMENTATION.md` as needed

**Backend Developer (API Integration):**
1. Start with `QUICK_START.md`
2. Read `API_DOCUMENTATION.md` (HttpController section)
3. Reference `ARCHITECTURE_GUIDE.md` for data flow

**Full Stack Developer:**
1. Read all documentation in order
2. Start with `QUICK_START.md`
3. Deep dive into `ARCHITECTURE_GUIDE.md`

**New Team Member:**
1. `QUICK_START.md` - Get familiar with basics
2. `ARCHITECTURE_GUIDE.md` - Understand the structure
3. `WIDGETS_DOCUMENTATION.md` - Learn UI components
4. `API_DOCUMENTATION.md` - Reference as needed

---

### By Task

**I want to...**

- **Add a new HTTP request feature**
  → `QUICK_START.md` → `API_DOCUMENTATION.md` (HttpController)

- **Create a new UI component**
  → `QUICK_START.md` → `WIDGETS_DOCUMENTATION.md`

- **Understand the architecture**
  → `ARCHITECTURE_GUIDE.md`

- **Fix a bug**
  → `QUICK_START.md` (Debugging) → Relevant documentation

- **Optimize performance**
  → `ARCHITECTURE_GUIDE.md` (Performance Optimization)

- **Add a new language**
  → `QUICK_START.md` (Localization) → `API_DOCUMENTATION.md` (LocaleController)

- **Change the theme**
  → `QUICK_START.md` (Theming) → `API_DOCUMENTATION.md` (ThemeController)

---

## 📖 Documentation Structure

```
docs/
├── README.md                      # This file
├── QUICK_START.md                 # Quick reference (start here!)
├── API_DOCUMENTATION.md           # Complete API reference
├── WIDGETS_DOCUMENTATION.md       # UI components guide
└── ARCHITECTURE_GUIDE.md          # Architecture & best practices
```

---

## 🔑 Key Concepts

### Controllers
- **HttpController:** Main controller for HTTP requests, collections, environments, and history
- **ThemeController:** Manages application theme (light/dark/system)
- **LocaleController:** Handles language switching
- **UpdateController:** Checks for and manages app updates

### Models
- **HttpRequestModel:** Represents a single HTTP request
- **CollectionModel:** Groups related HTTP requests
- **HttpResponseModel:** Represents HTTP response data
- **EnvironmentModel:** Contains environment-specific variables
- **HistoryModel:** Stores request history

### State Management
- Uses **GetX** for reactive programming
- Observables (`.obs`) for reactive state
- `Obx()` for reactive UI updates
- GetXStorage for persistence

### Architecture
- **Clean Architecture** with separation of concerns
- **MVC pattern** for organization
- **Repository pattern** for data access
- **Observer pattern** for reactive updates
- **Dependency Injection** via GetX bindings

---

## 🚀 Getting Started

### Step 1: Setup
```bash
flutter pub get
flutter run
```

### Step 2: Read Documentation
1. Start with `QUICK_START.md`
2. Explore relevant sections based on your task

### Step 3: Explore Code
- Open `lib/controller/http_controller.dart` to understand main logic
- Open `lib/views/home_view.dart` to see main layout
- Open `lib/widgets/sidebar_widget.dart` to see collections UI

### Step 4: Start Coding
- Follow patterns from existing code
- Reference documentation as needed
- Ask questions if unclear

---

## 📝 Common Tasks

### Send HTTP Request
See: `QUICK_START.md` → Common Tasks → Send HTTP Request

### Create Collection
See: `QUICK_START.md` → Common Tasks → Create Collection

### Use Environment Variables
See: `QUICK_START.md` → Common Tasks → Use Environment Variables

### Add New Feature
See: `ARCHITECTURE_GUIDE.md` → Development Guidelines → Adding a New Feature

### Optimize Performance
See: `ARCHITECTURE_GUIDE.md` → Performance Optimization

---

## 🎨 Code Examples

### Basic Request
```dart
final controller = Get.find<HttpController>();
controller.httpMethod.value = 'GET';
controller.url.value = 'https://api.example.com/users';
await controller.sendRequest();
```

### Reactive UI
```dart
Obx(() => Text(controller.url.value))
```

### Collections
```dart
controller.addCollection('My API');
controller.addRequest(collectionId, request);
```

### Environment Variables
```dart
controller.addEnvironment('Production');
controller.addEnvironmentVariable(envId, 'base_url', 'https://api.prod.com');
controller.url.value = '{{base_url}}/users';
```

---

## 🔍 Finding Information

### By Class Name
- **HttpController** → `API_DOCUMENTATION.md` → Controllers → HttpController
- **SidebarWidget** → `WIDGETS_DOCUMENTATION.md` → Main Widgets → SidebarWidget
- **HttpRequestModel** → `API_DOCUMENTATION.md` → Models → HttpRequestModel

### By Feature
- **HTTP Requests** → `API_DOCUMENTATION.md` → HttpController → HTTP Request Methods
- **Collections** → `API_DOCUMENTATION.md` → HttpController → Collection Management Methods
- **Environments** → `API_DOCUMENTATION.md` → HttpController → Environment Methods
- **History** → `API_DOCUMENTATION.md` → HttpController → History Methods

### By Pattern
- **State Management** → `ARCHITECTURE_GUIDE.md` → State Management
- **Error Handling** → `ARCHITECTURE_GUIDE.md` → Best Practices → Error Handling
- **Performance** → `ARCHITECTURE_GUIDE.md` → Best Practices → Performance
- **Testing** → `ARCHITECTURE_GUIDE.md` → Development Guidelines → Testing Guidelines

---

## 💡 Tips

1. **Use Ctrl+F** to search within documentation files
2. **Start with QUICK_START.md** if you're new
3. **Reference API_DOCUMENTATION.md** for detailed information
4. **Check ARCHITECTURE_GUIDE.md** for best practices
5. **Look at existing code** for examples

---

## 🐛 Troubleshooting

### Can't find what you're looking for?
1. Check the "Quick Navigation" section above
2. Use Ctrl+F to search documentation
3. Check the "Finding Information" section
4. Look at existing code examples

### Documentation unclear?
1. Check related sections
2. Look at code examples
3. Check QUICK_START.md for common patterns

---

## 📚 Additional Resources

- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design](https://material.io/design)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 📞 Support

For questions or issues:
1. Check the relevant documentation file
2. Search for similar issues in code
3. Check troubleshooting sections
4. Ask team members

---

## 📋 Documentation Checklist

- ✅ QUICK_START.md - Quick reference guide
- ✅ API_DOCUMENTATION.md - Complete API reference
- ✅ WIDGETS_DOCUMENTATION.md - UI components guide
- ✅ ARCHITECTURE_GUIDE.md - Architecture & best practices
- ✅ README.md - This file

---

## 🎯 Next Steps

1. **Read QUICK_START.md** to get familiar with basics
2. **Explore the codebase** using the documentation as reference
3. **Start implementing features** following the patterns
4. **Reference documentation** as needed during development

---

**Last Updated:** November 28, 2025

**Version:** 1.0.0

