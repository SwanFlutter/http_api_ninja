# HTTP API Ninja 🥷

یک کلاینت HTTP قدرتمند و مدرن ساخته شده با Flutter و GetX - جایگزینی برای Postman و Thunder Client

<div dir="rtl">

## 📸 تصاویر

![Welcome Screen](screenshots/welcome.png)
![Dark Theme](screenshots/dark_theme.png)
![Light Theme](screenshots/light_theme.png)

## ✨ ویژگی‌های کلیدی

### 🎯 قابلیت‌های اصلی
- **درخواست‌های HTTP کامل**: پشتیبانی از GET, POST, PUT, DELETE, PATCH
- **مدیریت Collection**: سازماندهی درخواست‌ها در collection‌های قابل گسترش
- **سازنده درخواست پیشرفته**: 6 تب برای تنظیمات دقیق
  - Query Parameters
  - Headers
  - Authentication (Basic, Bearer Token, API Key)
  - Body (JSON, Form Data, Raw)
  - Tests
  - Pre-run Scripts
- **ناحیه پاسخ جامع**: 6 تب برای تحلیل پاسخ
  - Response Body با فرمت‌بندی JSON
  - Response Headers
  - Cookies
  - Test Results
  - Documentation
  - Code Snippets (20+ زبان برنامه‌نویسی)

### 🎨 رابط کاربری
- **طراحی مدرن**: الهام گرفته از Thunder Client
- **تم تیره/روشن**: تغییر آسان بین حالت‌های مختلف
- **پنل‌های قابل تغییر اندازه**: سفارشی‌سازی فضای کاری
- **پاسخگو و روان**: تجربه کاربری عالی

### 🌍 چندزبانه
- فارسی (Persian)
- انگلیسی (English)
- عربی (Arabic)
- آلمانی (German)
- فرانسوی (French)

### 💾 ذخیره‌سازی
- **ذخیره خودکار**: تمام درخواست‌ها به صورت خودکار ذخیره می‌شوند
- **GetX Storage**: ذخیره‌سازی سریع و کارآمد
- **تاریخچه فعالیت**: دسترسی سریع به درخواست‌های اخیر

## 🚀 شروع سریع

### پیش‌نیازها
```bash
Flutter SDK >= 3.0.0
Dart SDK >= 3.0.0
```

### نصب

1. کلون کردن مخزن:
```bash
git clone https://github.com/yourusername/http_api_ninja.git
cd http_api_ninja
```

2. نصب وابستگی‌ها:
```bash
flutter pub get
```

3. اجرای برنامه:
```bash
# برای Windows
flutter run -d windows

# برای macOS
flutter run -d macos

# برای Linux
flutter run -d linux

# برای Web
flutter run -d chrome
```

## 📖 راهنمای استفاده

### ایجاد Collection جدید
1. روی دکمه "New Collection" کلیک کنید
2. نام collection را وارد کنید
3. روی "Create" کلیک کنید

### ایجاد درخواست جدید
1. روی دکمه "New Request" کلیک کنید
2. نام درخواست را وارد کنید
3. متد HTTP را انتخاب کنید
4. Collection مورد نظر را انتخاب کنید
5. روی "Create" کلیک کنید

### ارسال درخواست
1. یک درخواست را از sidebar انتخاب کنید
2. URL را وارد کنید
3. پارامترها، هدرها و بدنه را تنظیم کنید
4. روی دکمه "Send" کلیک کنید

### تب‌های Sidebar
- **Activity**: نمایش درخواست‌های اخیر
- **Collections**: مدیریت collection‌ها و درخواست‌ها
- **Env**: متغیرهای محیطی (به زودی)

## 🛠️ تکنولوژی‌ها

- **Flutter**: فریمورک UI
- **GetX**: مدیریت state و routing
- **GetX Storage**: ذخیره‌سازی محلی
- **HTTP**: ارسال درخواست‌های HTTP

## 📦 وابستگی‌های اصلی

```yaml
dependencies:
  flutter:
    sdk: flutter
  get_x_master: ^1.0.0
  get_x_storage: ^1.0.0
  http: ^1.2.2
```

## 🎨 تم‌سازی

برنامه از سیستم تم پیشرفته استفاده می‌کند که شامل:
- رنگ‌های سفارشی برای حالت تیره و روشن
- فونت‌های بهینه شده
- انیمیشن‌های روان

## 🌐 بین‌المللی‌سازی

برای افزودن زبان جدید:
1. فایل ترجمه جدید در `lib/I18n/` ایجاد کنید
2. کلاس ترجمه را به `lib/I18n/translations.dart` اضافه کنید
3. زبان را به `LocaleController` اضافه کنید

## 🤝 مشارکت

مشارکت‌ها همیشه خوش‌آمد هستند! لطفاً:
1. پروژه را Fork کنید
2. یک branch جدید ایجاد کنید
3. تغییرات خود را commit کنید
4. به branch خود push کنید
5. یک Pull Request ایجاد کنید

برای جزئیات بیشتر، [CONTRIBUTING.md](CONTRIBUTING.md) را مطالعه کنید.

## 📝 لایسنس

این پروژه تحت لایسنس MIT منتشر شده است - فایل [LICENSE](LICENSE) را برای جزئیات مشاهده کنید.

## 🙏 تشکر

- الهام گرفته از [Thunder Client](https://www.thunderclient.com/)
- ساخته شده با ❤️ توسط تیم توسعه

## 📞 تماس

- GitHub: [@SwanFlutter](https://github.com/SwanFlutter/http_api_ninja)
- Email: swan.dev1993@gmail.com

## 🗺️ نقشه راه

### تکمیل‌شده

- [x] متغیرهای محیطی ✅ (v1.1.0)
- [x] تاریخچه درخواست‌ها ✅ (v1.1.0)
- [x] تغییر نام مجموعه‌ها ✅ (v1.1.0)
- [x] هایلایت سینتکس Code Snippet ✅ (v1.1.0)
- [x] Base URL کالکشن ✅ (v1.1.1)
- [x] Import مجموعه (curl, Postman, JSON, URL, Raw) ✅ (v1.1.2–v1.1.3)
- [x] Export مجموعه به JSON ✅ (v1.1.3)
- [x] سیستم پیشرفته `{{variable}}` و متغیر در Body ✅ (v1.1.4)
- [x] Base URL کالکشن برای زیرپوشه‌ها ✅ (v1.1.4)
- [x] سایدبار و پنل Response قابل تغییر اندازه ✅ (v1.1.4)
- [x] اعلان‌های Toast سفارشی ✅ (v1.1.4)

### برنامه‌ریزی‌شده

- [ ] WebSocket Support
- [ ] GraphQL Support (کلاینت کامل)
- [ ] Mock Server
- [ ] Team Collaboration
- [ ] Cloud Sync
- [ ] Mobile Apps (Android & iOS)

---

**ساخته شده با Flutter 💙**

</div>
