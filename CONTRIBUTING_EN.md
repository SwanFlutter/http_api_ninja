# Contributing Guide

We're excited that you want to contribute to HTTP API Ninja! 🎉

## 📋 Table of Contents
1. [Getting Started](#getting-started)
2. [Code Standards](#code-standards)
3. [Pull Request Process](#pull-request-process)
4. [Bug Reports](#bug-reports)
5. [Feature Requests](#feature-requests)

## 🚀 Getting Started

### Prerequisites
```bash
Flutter SDK >= 3.9.2
Dart SDK >= 3.9.2
Git
```

### Development Environment Setup

1. **Fork the Project**
   - Go to the project's GitHub page
   - Click the "Fork" button

2. **Clone the Project**
   ```bash
   git clone https://github.com/YOUR_USERNAME/http_api_ninja.git
   cd http_api_ninja
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the Project**
   ```bash
   flutter run -d windows
   ```

5. **Create a New Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 Code Standards

### Project Structure
```
lib/
├── bindings/       # GetX Bindings
├── config/         # Configuration and constants
├── controller/     # GetX Controllers
├── I18n/          # Translation files
├── models/        # Data models
├── theme/         # Themes
├── views/         # Main pages
├── widgets/       # Reusable widgets
└── main.dart      # Entry point
```

### Naming Conventions

#### Files
```dart
// ✅ Correct
user_controller.dart
http_request_model.dart
sidebar_widget.dart

// ❌ Wrong
UserController.dart
httpRequestModel.dart
SideBar.dart
```

#### Classes
```dart
// ✅ Correct
class UserController extends GetXController {}
class HttpRequestModel {}
class SidebarWidget extends StatelessWidget {}

// ❌ Wrong
class userController extends GetXController {}
class httpRequestModel {}
class sidebar_widget extends StatelessWidget {}
```

#### Variables
```dart
// ✅ Correct
final userName = 'John';
final isLoading = false.obs;
const maxRetries = 3;

// ❌ Wrong
final UserName = 'John';
final is_loading = false.obs;
const MAX_RETRIES = 3;
```

### Code Style

#### Use const
```dart
// ✅ Correct
const SizedBox(height: 16)
const EdgeInsets.all(8)

// ❌ Wrong
SizedBox(height: 16)
EdgeInsets.all(8)
```

#### Formatting
```bash
# Format code before commit
flutter format .
```

#### Linting
```bash
# Check code issues
flutter analyze
```

### Comments

```dart
/// Complete method description
/// 
/// [param1] First parameter description
/// [param2] Second parameter description
/// 
/// Returns: Output description
Future<void> sendRequest(String url, String method) async {
  // Short explanation for code line
  final response = await _connect.get(url);
  
  // TODO: Implement error handling
}
```

## 🔄 Pull Request Process

### Before Submitting PR

1. **Check Code**
   ```bash
   flutter analyze
   flutter format .
   ```

2. **Test**
   ```bash
   flutter test
   flutter run -d windows
   ```

3. **Commit**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

### Git Policy (no AI attribution)

- Commits must be attributed to the **human contributor** who authored the PR.
- Do **not** add to commit messages or footers:
  - `Co-authored-by: Cursor <cursoragent@cursor.com>`
  - `Co-authored-by` lines for ChatGPT, Copilot, Claude, or any other AI tool
- Using an AI assistant does not require credit in Git history.
- Prefer `git commit` from the terminal to avoid IDE-injected co-author trailers.
- Before pushing, run `git log -1 --format=%B` and confirm only your message is present.

### Commit Message Format

```
type(scope): subject

body

footer
```

#### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

#### Examples
```bash
feat(http): add GraphQL support
fix(ui): resolve sidebar overflow issue
docs(readme): update installation guide
style(theme): improve dark mode colors
refactor(controller): simplify http logic
test(http): add unit tests for requests
chore(deps): update dependencies
```

### Submitting PR

1. **Push**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**
   - Go to GitHub page
   - Click "New Pull Request"
   - Write complete description

3. **PR Template**
   ```markdown
   ## Description
   Complete description of changes

   ## Type of Changes
   - [ ] New feature
   - [ ] Bug fix
   - [ ] Performance improvement
   - [ ] UI changes
   - [ ] Documentation

   ## Checklist
   - [ ] Code is formatted
   - [ ] Tests pass
   - [ ] Documentation updated
   - [ ] Changes logged in CHANGELOG

   ## Screenshots
   (If UI changes)
   ```

## 🐛 Bug Reports

### Bug Report Template

```markdown
## Bug Description
Clear and concise description of the bug

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll to '...'
4. See error

## Expected Behavior
Description of correct behavior

## Current Behavior
Description of incorrect behavior

## Screenshots
(If applicable)

## Environment
- OS: [e.g. Windows 11]
- Flutter Version: [e.g. 3.9.2]
- App Version: [e.g. 1.0.0]

## Additional Information
Any other useful information
```

## 💡 Feature Requests

### Request Template

```markdown
## Feature Description
Clear description of proposed feature

## Motivation
Why is this feature useful?

## Proposed Solution
How should it be implemented?

## Alternatives
Other solutions you've considered

## Additional Information
Examples, screenshots, links
```

## 🎨 UI/UX Guidelines

### Colors
```dart
// Dark Theme
primaryColor: #FF6B9D
backgroundColor: #1E1E1E
surfaceColor: #252526

// Light Theme
primaryColor: #FF6B9D
backgroundColor: #F5F5F5
surfaceColor: #FFFFFF
```

### Spacing
```dart
// Standard
padding: EdgeInsets.all(16)
margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4)
gap: SizedBox(height: 16)
```

### Fonts
```dart
// Sizes
fontSize: 13  // Regular text
fontSize: 16  // Headings
fontSize: 12  // Small text

// Weights
FontWeight.normal   // Regular text
FontWeight.w600     // Emphasized text
FontWeight.bold     // Headings
```

## 🧪 Testing

### Unit Tests
```dart
test('should send GET request', () async {
  final controller = HttpController();
  await controller.sendRequest();
  expect(controller.isLoading.value, false);
});
```

### Widget Tests
```dart
testWidgets('should display sidebar', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.byType(SidebarWidget), findsOneWidget);
});
```

## 📚 Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Material Design](https://material.io/design)

## 🤝 Code of Conduct

### Rules
1. Respect all contributors
2. Accept constructive criticism
3. Focus on the best solution
4. Help each other

### Prohibited
- Offensive language
- Personal attacks
- Spam
- Unprofessional behavior

## 📞 Contact Team

- **Issues**: For bugs and suggestions
- **Discussions**: For general questions
- **Email**: support@example.com

## 🎁 Acknowledgments

Thank you to all human contributors! 🙏

Your name is recorded as the commit/PR author on GitHub. AI tools are not listed as co-authors or contributors.

---

**Thank you for your contribution! 🚀**
