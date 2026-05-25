# راهنمای مشارکت در پروژه

خوشحالیم که می‌خواهید در توسعه HTTP API Ninja مشارکت کنید! 🎉

## 📋 فهرست مطالب
1. [نحوه شروع](#نحوه-شروع)
2. [استانداردهای کد](#استانداردهای-کد)
3. [فرآیند Pull Request](#فرآیند-pull-request)
4. [گزارش باگ](#گزارش-باگ)
5. [پیشنهاد ویژگی جدید](#پیشنهاد-ویژگی-جدید)

## 🚀 نحوه شروع

### پیش‌نیازها
```bash
Flutter SDK >= 3.9.2
Dart SDK >= 3.9.2
Git
```

### راه‌اندازی محیط توسعه

1. **Fork کردن پروژه**
   - به صفحه GitHub پروژه بروید
   - روی دکمه "Fork" کلیک کنید

2. **Clone کردن پروژه**
   ```bash
   git clone https://github.com/YOUR_USERNAME/http_api_ninja.git
   cd http_api_ninja
   ```

3. **نصب Dependencies**
   ```bash
   flutter pub get
   ```

4. **اجرای پروژه**
   ```bash
   flutter run -d windows
   ```

5. **ایجاد Branch جدید**
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 استانداردهای کد

### ساختار پروژه
```
lib/
├── bindings/       # GetX Bindings
├── config/         # تنظیمات و ثابت‌ها
├── controller/     # کنترلرهای GetX
├── I18n/          # فایل‌های ترجمه
├── models/        # مدل‌های داده
├── theme/         # تم‌ها
├── views/         # صفحات اصلی
├── widgets/       # ویجت‌های قابل استفاده مجدد
└── main.dart      # نقطه شروع
```

### قوانین نام‌گذاری

#### فایل‌ها
```dart
// ✅ درست
user_controller.dart
http_request_model.dart
sidebar_widget.dart

// ❌ غلط
UserController.dart
httpRequestModel.dart
SideBar.dart
```

#### کلاس‌ها
```dart
// ✅ درست
class UserController extends GetXController {}
class HttpRequestModel {}
class SidebarWidget extends StatelessWidget {}

// ❌ غلط
class userController extends GetXController {}
class httpRequestModel {}
class sidebar_widget extends StatelessWidget {}
```

#### متغیرها
```dart
// ✅ درست
final userName = 'John';
final isLoading = false.obs;
const maxRetries = 3;

// ❌ غلط
final UserName = 'John';
final is_loading = false.obs;
const MAX_RETRIES = 3;
```

### استایل کد

#### استفاده از const
```dart
// ✅ درست
const SizedBox(height: 16)
const EdgeInsets.all(8)

// ❌ غلط
SizedBox(height: 16)
EdgeInsets.all(8)
```

#### Formatting
```bash
# قبل از commit، کد را فرمت کنید
flutter format .
```

#### Linting
```bash
# بررسی مشکلات کد
flutter analyze
```

### کامنت‌گذاری

```dart
/// توضیحات کامل متد
/// 
/// [param1] توضیح پارامتر اول
/// [param2] توضیح پارامتر دوم
/// 
/// Returns: توضیح خروجی
Future<void> sendRequest(String url, String method) async {
  // توضیح کوتاه برای خط کد
  final response = await _connect.get(url);
  
  // TODO: پیاده‌سازی error handling
}
```

## 🔄 فرآیند Pull Request

### قبل از ارسال PR

1. **بررسی کد**
   ```bash
   flutter analyze
   flutter format .
   ```

2. **تست کردن**
   ```bash
   flutter test
   flutter run -d windows
   ```

3. **Commit کردن**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

### سیاست Git (بدون attribution ابزار AI)

- commitها فقط به نام **مشارکت‌کننده انسانی** (نویسنده واقعی PR) ثبت شوند.
- در پیام commit یا footer از این موارد **استفاده نکنید**:
  - `Co-authored-by: Cursor <cursoragent@cursor.com>`
  - `Co-authored-by` برای ChatGPT، Copilot، Claude یا هر ابزار AI دیگر
- اگر از Cursor/IDE کمک گرفتید، نیازی به ذکر آن در تاریخچه Git نیست.
- ترجیحاً commit را از ترمینال با `git commit` بزنید تا footer اضافی اضافه نشود.
- قبل از push: `git log -1 --format=%B` را بررسی کنید که فقط پیام شما باشد.

### قالب Commit Message

```
type(scope): subject

body

footer
```

#### Types
- `feat`: ویژگی جدید
- `fix`: رفع باگ
- `docs`: تغییرات مستندات
- `style`: تغییرات استایل کد
- `refactor`: بازنویسی کد
- `test`: افزودن تست
- `chore`: کارهای نگهداری

#### مثال‌ها
```bash
feat(http): add GraphQL support
fix(ui): resolve sidebar overflow issue
docs(readme): update installation guide
style(theme): improve dark mode colors
refactor(controller): simplify http logic
test(http): add unit tests for requests
chore(deps): update dependencies
```

### ارسال PR

1. **Push کردن**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **ایجاد Pull Request**
   - به صفحه GitHub بروید
   - روی "New Pull Request" کلیک کنید
   - توضیحات کامل بنویسید

3. **قالب PR**
   ```markdown
   ## توضیحات
   توضیح کامل تغییرات

   ## نوع تغییرات
   - [ ] ویژگی جدید
   - [ ] رفع باگ
   - [ ] بهبود عملکرد
   - [ ] تغییرات UI
   - [ ] مستندات

   ## چک‌لیست
   - [ ] کد فرمت شده است
   - [ ] تست‌ها پاس می‌شوند
   - [ ] مستندات به‌روز شده
   - [ ] تغییرات در CHANGELOG ثبت شده

   ## اسکرین‌شات
   (در صورت تغییرات UI)
   ```

## 🐛 گزارش باگ

### قالب گزارش باگ

```markdown
## توضیحات باگ
توضیح واضح و مختصر باگ

## مراحل بازتولید
1. برو به '...'
2. کلیک کن روی '...'
3. اسکرول کن به '...'
4. خطا را ببین

## رفتار مورد انتظار
توضیح رفتار صحیح

## رفتار فعلی
توضیح رفتار اشتباه

## اسکرین‌شات
(در صورت امکان)

## محیط
- OS: [e.g. Windows 11]
- Flutter Version: [e.g. 3.9.2]
- App Version: [e.g. 1.0.0]

## اطلاعات اضافی
هر اطلاعات دیگری که مفید باشد
```

## 💡 پیشنهاد ویژگی جدید

### قالب پیشنهاد

```markdown
## توضیحات ویژگی
توضیح واضح ویژگی پیشنهادی

## انگیزه
چرا این ویژگی مفید است؟

## راه‌حل پیشنهادی
چگونه باید پیاده‌سازی شود?

## جایگزین‌ها
راه‌حل‌های دیگر که در نظر گرفته‌اید

## اطلاعات اضافی
مثال‌ها، اسکرین‌شات، لینک‌ها
```

## 🎨 راهنمای UI/UX

### رنگ‌ها
```dart
// تم دارک
primaryColor: #FF6B9D
backgroundColor: #1E1E1E
surfaceColor: #252526

// تم روشن
primaryColor: #FF6B9D
backgroundColor: #F5F5F5
surfaceColor: #FFFFFF
```

### فاصله‌گذاری
```dart
// استاندارد
padding: EdgeInsets.all(16)
margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4)
gap: SizedBox(height: 16)
```

### فونت‌ها
```dart
// سایزها
fontSize: 13  // متن عادی
fontSize: 16  // عنوان‌ها
fontSize: 12  // متن کوچک

// وزن
FontWeight.normal   // متن عادی
FontWeight.w600     // متن برجسته
FontWeight.bold     // عنوان‌ها
```

## 🧪 تست‌نویسی

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

## 📚 منابع مفید

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Material Design](https://material.io/design)

## 🤝 کد رفتار (Code of Conduct)

### قوانین
1. احترام به همه مشارکت‌کنندگان
2. پذیرش نقد سازنده
3. تمرکز روی بهترین راه‌حل
4. کمک به یکدیگر

### ممنوعیت‌ها
- زبان توهین‌آمیز
- حمله شخصی
- هرزنامه (Spam)
- رفتار غیرحرفه‌ای

## 📞 ارتباط با تیم

- **Issues**: برای باگ و پیشنهادات
- **Discussions**: برای سوالات عمومی
- **Email**: support@example.com

## 🎁 قدردانی

از تمام مشارکت‌کنندگان انسانی پروژه تشکر می‌کنیم! 🙏

نام شما (به‌عنوان نویسنده commit/PR) در تاریخچه GitHub ثبت می‌شود. ابزارهای AI به‌عنوان co-author یا contributor لیست نمی‌شوند.

---

**با تشکر از مشارکت شما! 🚀**
