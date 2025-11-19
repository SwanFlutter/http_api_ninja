# Changelog

All notable changes to this project will be documented in this file.

## [1.0.1] - 2025-11-18

### ✨ New Features

#### Welcome Screen
- Beautiful welcome screen with large logo (180x180 pixels)
- Quick action cards (New Request, New Collection, Recent Activity)
- Dynamic theme support (dark/light)
- Gradient background
- Displayed when no request is selected

#### Custom Notification System
- Notification banner at the bottom of the screen
- Color-coded by type (Success, Error, Info)
- Manual close button
- Auto-dismiss after 3 seconds
- No Overlay context required

#### Response Display with Syntax Highlighting
- Integration of flutter_code_view package
- JSON syntax highlighting
- Line numbers display
- Dracula theme for dark mode
- GitHub theme for light mode
- Copy button for response

#### Improved Headers Display
- Table format display
- Header and Value columns
- Appropriate color coding
- Selectable and copyable text
- Copy All Headers button

### 🔧 Improvements

#### Better Error Handling
- Null response handling
- User-friendly error messages
- Better timeout handling (30 seconds)
- Error details in response

#### Performance
- Improved response speed
- Reduced memory usage
- Better async operations management

#### User Interface
- Status code display in notifications
- Better color coding for success/error
- Smoother animations

#### Code
- Refactored sendRequest method
- Added _sendHttpRequest helper method
- Improved error handling
- Cleaner and more maintainable code

### 🐛 Bug Fixes

1. **Application Hanging**
   - Cause: null response
   - Solution: null check before processing

2. **"No Overlay widget found" Error**
   - Cause: Get.snackbar requiring Overlay context
   - Solution: Custom notification system

3. **Opacity Assertion Error**
   - Cause: Incorrect use of withValues
   - Solution: Use withOpacity

4. **UI Overflow**
   - Cause: Too much content on small screen
   - Solution: Use SingleChildScrollView and Wrap

5. **Timeout Handling**
   - Cause: Improper timeout management
   - Solution: Use Future.any

---

## [1.0.0] - 2025-11-18

### ✨ Initial Release

#### Core Features
- **Complete HTTP Client**
  - Support for all HTTP methods (GET, POST, PUT, DELETE, PATCH)
  - Concurrent request sending
  - Timeout and error management

- **Collection Management**
  - Create and delete collections
  - Organize requests
  - Expandable folders

- **Advanced Request Builder**
  - Query Parameters tab
  - Headers tab with enable/disable
  - Authentication tab (Basic, Bearer, API Key)
  - Body tab (JSON, Form Data, Raw)
  - Tests tab for automated testing
  - Pre-run Scripts tab

- **Comprehensive Response Area**
  - Response Body with JSON formatting
  - Response Headers display
  - Cookies display
  - Test results display
  - Code Snippet generation for 20+ languages
  - API documentation

#### User Interface
- **Modern Design**
  - Inspired by Thunder Client
  - Professional color scheme
  - Clear and beautiful icons

- **Dark/Light Theme**
  - Dark mode with appropriate colors
  - Light mode with high contrast
  - Easy switching from settings

- **Resizable Panels**
  - Adjustable Response Area width
  - Save user settings
  - Custom user experience

- **Sidebar with 3 Tabs**
  - Activity: Recent requests display
  - Collections: Collection management
  - Env: Environment variables (coming soon)

#### Multi-language Support
- Support for 5 languages:
  - English
  - Persian (فارسی)
  - Arabic (العربية)
  - German (Deutsch)
  - French (Français)

#### Storage
- **GetX Storage**
  - Auto-save all requests
  - Save collections
  - Save user settings
  - Fast data recovery

### 🎨 UI/UX Improvements
- Request status display (Loading)
- Response time display
- Response size display
- HTTP method color coding
- Snackbar for success/error messages

### 📚 Documentation
- Complete README
- Usage guide
- Contributing guide
- TODO list

---

**Initial release with all core features**

For Persian changelog, see [CHANGELOG_FA.md](CHANGELOG_FA.md)
