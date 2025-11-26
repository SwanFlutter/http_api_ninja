# HTTP API Ninja 🥷

A powerful and modern HTTP client built with Flutter and Get_x_master - An alternative to Postman and Thunder Client

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)](https://flutter.dev/desktop)

## 📸 Screenshots

<img width="1024" height="1024" alt="logo_dark" src="https://github.com/user-attachments/assets/22234579-8f7f-4e6a-a7f4-c2087fe41eaa" />

<img width="1920" height="1017" alt="30" src="https://github.com/user-attachments/assets/ed47fdea-86eb-435a-ab84-0ea2626e4043" />



## ✨ Key Features

### 🎯 Core Functionality
- **Complete HTTP Requests**: Support for GET, POST, PUT, DELETE, PATCH
- **Collection Management**: Organize requests in expandable collections
- **Advanced Request Builder**: 6 tabs for precise configuration
  - Query Parameters
  - Headers
  - Authentication (Basic, Bearer Token, API Key)
  - Body (JSON, Form Data, Raw)
  - Tests
  - Pre-run Scripts
- **Comprehensive Response Area**: 6 tabs for response analysis
  - Response Body with JSON syntax highlighting
  - Response Headers (Table view)
  - Cookies
  - Test Results
  - Documentation
  - Code Snippets (20+ programming languages)

### 🎨 User Interface
- **Modern Design**: Inspired by Thunder Client
- **Dark/Light Theme**: Easy switching between modes
- **Resizable Panels**: Customize your workspace
- **Responsive & Smooth**: Excellent user experience
- **Welcome Screen**: Beautiful landing page with quick actions

### 🌍 Multi-language Support
- English
- Persian (فارسی)
- Arabic (العربية)
- German (Deutsch)
- French (Français)

### 💾 Storage
- **Auto-save**: All requests are automatically saved
- **Get_x_Storage**: Fast and efficient storage
- **Request History**: Full history with search, filter, and restore
- **Environment Storage**: Save environments and variables

### 🌐 Environment Variables
- **Multiple Environments**: Dev, Staging, Production
- **Global Variables**: Shared across all environments
- **Variable Syntax**: Use `{{variable}}` in URL, Headers, Query Params
- **Import/Export**: JSON format support

### 🎨 Advanced Features
- **Syntax Highlighting**: JSON response with color coding
- **Line Numbers**: Easy code navigation
- **Copy to Clipboard**: One-click copy for responses and headers
- **Smart Notifications**: Custom notification system
- **Error Handling**: Robust error management with user-friendly messages

## 🚀 Quick Start

### Prerequisites
```bash
Flutter SDK >= 3.0.0
Dart SDK >= 3.0.0
```

### Installation

1. Clone the repository:
```bash
git clone https://github.com/SwanFlutter/http_api_ninja.git
cd http_api_ninja
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
# For Windows
flutter run -d windows

# For macOS
flutter run -d macos

# For Linux
flutter run -d linux

# For Web
flutter run -d chrome
```

## 📖 Usage Guide

### Creating a New Collection
1. Click the "New Collection" button
2. Enter the collection name
3. Click "Create"

### Creating a New Request
1. Click the "New Request" button
2. Enter the request name
3. Select the HTTP method
4. Choose the target collection
5. Click "Create"

### Sending a Request
1. Select a request from the sidebar
2. Enter the URL
3. Configure parameters, headers, and body
4. Click the "Send" button

### Sidebar Tabs
- **History**: View and search request history with filters
- **Collections**: Manage collections and requests (with rename support)
- **Env**: Full environment variables management

## 🛠️ Technologies

- **Flutter**: UI framework
- **GetX**: State management and routing
- **GetX Storage**: Local storage
- **HTTP**: HTTP request handling
- **flutter_code_view**: Syntax highlighting

## � Main Deیpendencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get_x_master: ^0.0.19
  get_x_storage: ^0.0.7
  flutter_code_view: ^0.0.3
```

## 🎨 Theming

The application uses an advanced theming system that includes:
- Custom colors for dark and light modes
- Optimized fonts
- Smooth animations
- Syntax highlighting themes (Dracula for dark, GitHub for light)

## 🌐 Internationalization

To add a new language:
1. Create a new translation file in `lib/I18n/`
2. Add the translation class to `lib/I18n/translations.dart`
3. Add the language to `LocaleController`

## 🤝 Contributing

Contributions are always welcome! Please:
1. Fork the project
2. Create a new branch
3. Commit your changes
4. Push to your branch
5. Create a Pull Request

For more details, read [CONTRIBUTING.md](CONTRIBUTING.md).

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by [Thunder Client](https://www.thunderclient.com/)


## 📞 Contact

- GitHub: [@SwanFlutter](https://github.com/SwanFlutter/http_api_ninja)
- Email: swan.dev1993@gmail.com

## 🗺️ Roadmap

- [x] Environment Variables ✅ (v1.1.0)
- [x] Request History ✅ (v1.1.0)
- [x] Rename Collections ✅ (v1.1.0)
- [x] Code Snippet Syntax Highlighting ✅ (v1.1.0)
- [ ] Import/Export Collections
- [ ] WebSocket Support
- [ ] GraphQL Support
- [ ] Mock Server
- [ ] Team Collaboration
- [ ] Cloud Sync
- [ ] Mobile Apps (Android & iOS)

## 🐛 Bug Reports

Found a bug? Please open an issue on GitHub with:
- Flutter version
- Operating system
- Error message
- Steps to reproduce
- Relevant logs

## 💡 Features

### Welcome Screen
- Large logo (180x180 pixels)
- Quick action cards
- Dynamic theme support
- Gradient background

### Notification System
- Custom notification banner
- Color-coded by type (Success, Error, Info)
- Auto-dismiss after 3 seconds
- Manual close button

### Response Display
- JSON syntax highlighting with line numbers
- Headers displayed in table format
- Copy buttons for easy clipboard access
- Selectable text

### Error Handling
- Null response handling
- 30-second timeout
- User-friendly error messages
- Network error detection

---

**Built with Flutter 💙**

For Persian documentation, see [README_FA.md](README_FA.md)
