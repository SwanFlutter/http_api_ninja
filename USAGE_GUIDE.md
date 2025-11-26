Here is the English version of your **HTTP API Ninja User Guide**:

---

# HTTP API Ninja User Guide

## 📖 Table of Contents
1. [Quick Start](#quick-start)
2. [Sending Requests](#sending-requests)
3. [Collection Management](#collection-management)
4. [Settings](#settings)
5. [Tips and Tricks](#tips-and-tricks)

---

## 🚀 Quick Start

### Send Your First Request
1. **Select HTTP Method**
   - Choose your desired method from the dropdown menu.
   - Available methods: GET, POST, PUT, DELETE, PATCH.

2. **Enter URL**
   - Input the full API URL in the designated field.
   - Example: `https://api.example.com/users`

3. **Send Request**
   - Click the "Send" button.
   - Wait for the response.

---

## 📤 Sending Requests

### HTTP Methods

#### GET – Retrieve Data
```http
Method: GET
URL: https://api.example.com/users
```
Use to fetch a list of users or specific information.

#### POST – Create New Data
```http
Method: POST
URL: https://api.example.com/users
Body:
{
  "name": "John Doe",
  "email": "john@example.com"
}
```

#### PUT – Full Update
```http
Method: PUT
URL: https://api.example.com/users/1
Body:
{
  "name": "John Updated",
  "email": "john.new@example.com"
}
```

#### DELETE – Delete Data
```http
Method: DELETE
URL: https://api.example.com/users/1
```

#### PATCH – Partial Update
```http
Method: PATCH
URL: https://api.example.com/users/1
Body:
{
  "name": "John Updated"
}
```

---

### Request Tabs

#### Query Parameters
Add URL parameters:
```
key: page
value: 1
key: limit
value: 10
```
Result: `https://api.example.com/users?page=1&limit=10`

#### Headers
Add custom headers:
```
Content-Type: application/json
Authorization: Bearer your-token-here
Accept: application/json
```

#### Auth
Authentication types:
- **No Auth**: No authentication
- **Bearer Token**: JWT token
- **Basic Auth**: Username and password
- **API Key**: API key

#### Body
Request content:
- **JSON**: For RESTful APIs
- **Form Data**: For file uploads
- **Raw**: Raw text
- **XML**: XML data

#### Tests
Automated response tests:
```javascript
// Check status code
response.status === 200
// Check content
response.body.data.length > 0
```

#### Pre Run
Pre-execution scripts:
```javascript
// Set variables
env.set('timestamp', Date.now());
```

---

## 📁 Collection Management

### Create a New Collection
1. Click the "New Request" button.
2. Configure the request.
3. It will be automatically saved in the Collection.

### Organize Requests
- Requests are grouped in folders.
- Click the folder icon to expand/collapse.
- Use the search feature to find requests quickly.

### Select a Request
- Click any request.
- Request details will be displayed.
- You can edit and resend it.

---

## 📊 Response Display

### Response Tabs

#### Response
- Displays formatted JSON response.
- Copy text feature.
- Color-coded for better readability.

#### Headers
- Shows all response headers.
- Includes Content-Type, Cache-Control, etc.

#### Cookies
- Displays received cookies.
- Manage cookies for future requests.

#### Results
- Shows automated test results.
- Pass/Fail status for each test.

#### Docs
- Auto-generated API documentation.
- Sample code for different languages.

### Response Information
- **Status**: HTTP status code (200, 404, 500, etc.)
- **Size**: Response size in kilobytes.
- **Time**: Response time in milliseconds.

---

## 🖥️ Terminal

### Terminal Display
- Located on the right side of the page.
- Shows detailed request and response information.
- Can be closed by clicking the X icon.

### Terminal Content
```
Request: GET https://api.example.com/users
Status: 200 OK    Size: 2.5 KB    Time: 234 ms
Response:
{
  "data": [
    {
      "id": 1,
      "name": "John Doe"
    }
  ]
}
```

---

## ⚙️ Settings

### Change Theme
1. Click the Settings icon.
2. Select your preferred theme:
   - **Light Mode**: Light theme
   - **Dark Mode**: Dark theme

### Change Language
1. Click the Settings icon.
2. Select your preferred language:
   - English
   - فارسی (Persian)
   - العربية (Arabic)
   - Deutsch (German)
   - Français (French)

---

## 💡 Tips and Tricks

### Keyboard Shortcuts
- `Ctrl + Enter`: Send request
- `Ctrl + N`: New request
- `Ctrl + S`: Save request
- `Ctrl + F`: Search in Collection

### Best Practices

#### 1. Naming Requests
```
✅ Good: "Get User Profile"
❌ Bad: "Request 1"
```

#### 2. Organizing Collections
```
📁 Users
  ├── Get All Users
  ├── Get User by ID
  ├── Create User
  └── Update User
📁 Products
  ├── Get All Products
  └── Create Product
```

#### 3. Using Variables
```
URL: {{base_url}}/users
Header: Authorization: Bearer {{token}}
```

#### 4. Automated Tests
```javascript
// Always check the status code
test("Status is 200", () => {
  expect(response.status).toBe(200);
});
// Check data structure
test("Response has data", () => {
  expect(response.body.data).toBeDefined();
});
```

### Troubleshooting Common Issues

#### CORS Error
```
Error: CORS policy blocked
Solution: Use a proxy or enable CORS on the server.
```

#### Timeout Error
```
Error: Request timeout
Solution: Increase the timeout in settings.
```

#### SSL Error
```
Error: SSL certificate problem
Solution: Disable "Verify SSL" (for development only).
```

---

## 🎓 Practical Examples

### Example 1: JWT Authentication
```
1. Login Request:
   POST https://api.example.com/auth/login
   Body:
   {
     "email": "user@example.com",
     "password": "password123"
   }
2. Get the token from the response.
3. Use it in subsequent requests:
   Header: Authorization: Bearer {token}
```

### Example 2: File Upload
```
POST https://api.example.com/upload
Content-Type: multipart/form-data
Body (Form Data):
  file: [Select file]
  description: "Profile picture"
```

### Example 3: Pagination
```
GET https://api.example.com/users?page=1&limit=10
Query Parameters:
  page: 1
  limit: 10
  sort: name
  order: asc
```

---

## 📞 Get Help
If you have questions or encounter issues:
1. Check the documentation.
2. Search the Issues section.
3. Create a new Issue.
4. Contact the support team.

---
**Happy testing! 🚀**





# راهنمای استفاده از HTTP API Ninja

## 📖 فهرست مطالب
1. [شروع سریع](#شروع-سریع)
2. [ارسال درخواست](#ارسال-درخواست)
3. [مدیریت Collection](#مدیریت-collection)
4. [تنظیمات](#تنظیمات)
5. [نکات و ترفندها](#نکات-و-ترفندها)

## 🚀 شروع سریع

### اولین درخواست خود را ارسال کنید

1. **انتخاب متد HTTP**
   - از منوی کشویی در بالای صفحه، متد مورد نظر را انتخاب کنید
   - متدهای موجود: GET, POST, PUT, DELETE, PATCH

2. **وارد کردن URL**
   - URL کامل API را در کادر مربوطه وارد کنید
   - مثال: `https://api.example.com/users`

3. **ارسال درخواست**
   - روی دکمه "Send" کلیک کنید
   - منتظر دریافت پاسخ بمانید

## 📤 ارسال درخواست

### متدهای HTTP

#### GET - دریافت داده
```
Method: GET
URL: https://api.example.com/users
```
برای دریافت لیست کاربران یا اطلاعات خاص

#### POST - ایجاد داده جدید
```
Method: POST
URL: https://api.example.com/users
Body: {
  "name": "John Doe",
  "email": "john@example.com"
}
```

#### PUT - به‌روزرسانی کامل
```
Method: PUT
URL: https://api.example.com/users/1
Body: {
  "name": "John Updated",
  "email": "john.new@example.com"
}
```

#### DELETE - حذف داده
```
Method: DELETE
URL: https://api.example.com/users/1
```

#### PATCH - به‌روزرسانی جزئی
```
Method: PATCH
URL: https://api.example.com/users/1
Body: {
  "name": "John Updated"
}
```

### تب‌های درخواست

#### Query Parameters
پارامترهای URL را اضافه کنید:
```
key: page
value: 1

key: limit
value: 10
```
نتیجه: `https://api.example.com/users?page=1&limit=10`

#### Headers
هدرهای سفارشی اضافه کنید:
```
Content-Type: application/json
Authorization: Bearer your-token-here
Accept: application/json
```

#### Auth
انواع احراز هویت:
- **No Auth**: بدون احراز هویت
- **Bearer Token**: توکن JWT
- **Basic Auth**: نام کاربری و رمز عبور
- **API Key**: کلید API

#### Body
محتوای درخواست:
- **JSON**: برای API های RESTful
- **Form Data**: برای آپلود فایل
- **Raw**: متن خام
- **XML**: داده‌های XML

#### Tests
تست‌های خودکار پاسخ:
```javascript
// بررسی کد وضعیت
response.status === 200

// بررسی محتوا
response.body.data.length > 0
```

#### Pre Run
اسکریپت‌های قبل از اجرا:
```javascript
// تنظیم متغیرها
env.set('timestamp', Date.now());
```

## 📁 مدیریت Collection

### ایجاد Collection جدید
1. روی دکمه "New Request" کلیک کنید
2. درخواست را پیکربندی کنید
3. به صورت خودکار در Collection ذخیره می‌شود

### سازماندهی درخواست‌ها
- درخواست‌ها در فولدرها گروه‌بندی می‌شوند
- روی آیکون فولدر کلیک کنید تا باز/بسته شود
- از جستجو برای یافتن سریع استفاده کنید

### انتخاب درخواست
- روی هر درخواست کلیک کنید
- اطلاعات درخواست در بالا نمایش داده می‌شود
- می‌توانید ویرایش و دوباره ارسال کنید

## 📊 نمایش پاسخ

### تب‌های پاسخ

#### Response
- نمایش محتوای پاسخ با فرمت JSON زیبا
- قابلیت کپی کردن متن
- نمایش رنگی برای خوانایی بهتر

#### Headers
- نمایش تمام هدرهای پاسخ
- اطلاعات Content-Type، Cache-Control و ...

#### Cookies
- نمایش کوکی‌های دریافتی
- مدیریت کوکی‌ها برای درخواست‌های بعدی

#### Results
- نتایج تست‌های خودکار
- نمایش Pass/Fail برای هر تست

#### Docs
- مستندات خودکار API
- نمونه کد برای زبان‌های مختلف

### اطلاعات پاسخ
- **Status**: کد وضعیت HTTP (200, 404, 500, ...)
- **Size**: حجم پاسخ به کیلوبایت
- **Time**: زمان پاسخ به میلی‌ثانیه

## 🖥️ ترمینال

### نمایش ترمینال
- ترمینال در سمت راست صفحه قرار دارد
- نمایش اطلاعات کامل درخواست و پاسخ
- قابلیت بستن با کلیک روی آیکون X

### محتوای ترمینال
```
Request: GET https://api.example.com/users
Status: 200 OK    Size: 2.5 KB    Time: 234 ms

Response:
{
  "data": [
    {
      "id": 1,
      "name": "John Doe"
    }
  ]
}
```

## ⚙️ تنظیمات

### تغییر تم
1. روی آیکون Settings کلیک کنید
2. از بخش Theme گزینه مورد نظر را انتخاب کنید:
   - **Light Mode**: تم روشن
   - **Dark Mode**: تم تاریک

### تغییر زبان
1. روی آیکون Settings کلیک کنید
2. از منوی Language زبان مورد نظر را انتخاب کنید:
   - English (انگلیسی)
   - فارسی (Persian)
   - العربية (عربی)
   - Deutsch (آلمانی)
   - Français (فرانسوی)

## 💡 نکات و ترفندها

### کلیدهای میانبر
- `Ctrl + Enter`: ارسال درخواست
- `Ctrl + N`: درخواست جدید
- `Ctrl + S`: ذخیره درخواست
- `Ctrl + F`: جستجو در Collection

### بهترین روش‌ها

#### 1. نام‌گذاری درخواست‌ها
```
✅ خوب: "Get User Profile"
❌ بد: "Request 1"
```

#### 2. سازماندهی Collection
```
📁 Users
  ├── Get All Users
  ├── Get User by ID
  ├── Create User
  └── Update User

📁 Products
  ├── Get All Products
  └── Create Product
```

#### 3. استفاده از متغیرها
```
URL: {{base_url}}/users
Header: Authorization: Bearer {{token}}
```

#### 4. تست‌های خودکار
```javascript
// همیشه کد وضعیت را بررسی کنید
test("Status is 200", () => {
  expect(response.status).toBe(200);
});

// ساختار داده را بررسی کنید
test("Response has data", () => {
  expect(response.body.data).toBeDefined();
});
```

### رفع مشکلات رایج

#### خطای CORS
```
Error: CORS policy blocked
راه حل: از پروکسی استفاده کنید یا CORS را در سرور فعال کنید
```

#### خطای Timeout
```
Error: Request timeout
راه حل: Timeout را در تنظیمات افزایش دهید
```

#### خطای SSL
```
Error: SSL certificate problem
راه حل: گزینه "Verify SSL" را غیرفعال کنید (فقط برای توسعه)
```

## 🎓 مثال‌های کاربردی

### مثال 1: احراز هویت با JWT
```
1. Login Request:
   POST https://api.example.com/auth/login
   Body: {
     "email": "user@example.com",
     "password": "password123"
   }

2. دریافت Token از پاسخ

3. استفاده در درخواست‌های بعدی:
   Header: Authorization: Bearer {token}
```

### مثال 2: آپلود فایل
```
POST https://api.example.com/upload
Content-Type: multipart/form-data

Body (Form Data):
  file: [انتخاب فایل]
  description: "Profile picture"
```

### مثال 3: Pagination
```
GET https://api.example.com/users?page=1&limit=10

Query Parameters:
  page: 1
  limit: 10
  sort: name
  order: asc
```

## 📞 دریافت کمک

اگر سوالی دارید یا به مشکلی برخوردید:
1. مستندات را مطالعه کنید
2. در بخش Issues جستجو کنید
3. یک Issue جدید ایجاد کنید
4. با تیم پشتیبانی تماس بگیرید

---

**موفق باشید! 🚀**
