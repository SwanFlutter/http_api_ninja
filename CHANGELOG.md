# Changelog

All notable changes to this project will be documented in this file.


## [1.1.2] - 2025-12-07

  * *Fix bug Collection BaseUrl**
   - Cause: Add base URL to each collection
   - Solution: Add base URL to each collection

- **Fix FontSize **
  - Cause: FontSize changed to 14px
  - Solution: FontSize changed to 14px

## [1.1.1] - 2025-12-03



- **Add Collection BaseUrl**
   - Cause: Add base URL to each collection
   - Solution: Add base URL to each collection


   - Example: https://example.com/api/
   - Cause: Add base URL to each collection
   - Solution: Add base URL to each collection
   - Example: https://example.com/api/

- **Fix FontSize Change**
  - Cause: FontSize changed to 14px
  - Solution: FontSize changed to 14px




## [1.1.0] - 2025-11-26

### ✨ New Features

#### Environment Variables System
- **Multiple Environments**: Create and manage Dev, Staging, Production environments
- **Variable Management**: Add, edit, delete variables per environment
- **Global Variables**: Shared variables across all environments
- **Variable Replacement**: Use `{{variable}}` syntax in URL, Headers, Query Params
- **Import/Export**: Export environment to JSON, import from JSON
- **Active Environment**: Quick switch between environments
- **Copy Variable Syntax**: One-click copy `{{variable}}` to clipboard

#### Complete History System
- **Auto-save History**: Every request is automatically saved to history
- **Search & Filter**: Search by URL or name, filter by HTTP method
- **History Details**: Status code, response time, response size, timestamp
- **Load from History**: One-click to restore request from history
- **Clear Options**: Clear all, clear older than 1 day/week
- **Maximum 100 Items**: Automatic cleanup of old entries

#### Collection Management Improvements
- **Rename Collection**: Right-click menu to rename collections
- **Better Organization**: Improved folder structure

#### Code Snippet with Syntax Highlighting
- **FlutterCodeView Integration**: Beautiful syntax highlighting
- **20+ Languages**: Dart, JavaScript, Python, Java, Go, PHP, Ruby, Swift, C#, Kotlin, etc.
- **Theme Support**: Dracula theme for dark mode, GitHub theme for light mode
- **Line Numbers**: Easy code navigation
- **Copy Button**: One-click copy generated code

### 🔧 Improvements

#### Variable Processing
- URL variables are replaced before sending request
- Header variables are replaced before sending request
- Query parameter variables are replaced before sending request

#### History Tab (Replaced Activity Tab)
- New modern design
- Better filtering options
- Response info display (time, size, status)
- Time ago format (Just now, 5m ago, 2h ago, etc.)

#### Environment Tab (Replaced Coming Soon)
- Full environment management UI
- Tabbed interface for Environment/Global variables
- Variable list with edit/delete actions

### 🐛 Bug Fixes

1. **FlutterCodeView Overflow**
   - Cause: Fixed height causing overflow
   - Solution: Wrap in SingleChildScrollView with dynamic sizing

2. **Variable Replacement**
   - Proper regex for `{{variable}}` pattern
   - Fallback to original if variable not found

---

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
