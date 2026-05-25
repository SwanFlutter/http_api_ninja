import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// کلاس سفارشی برای مدیریت Toast ها
/// استفاده آسان در تمام پروژه
class CustomToast {
  // جلوگیری از ساخت instance
  CustomToast._();

  /// تنظیمات پیش‌فرض
  static const Duration _defaultDuration = Duration(seconds: 3);
  static const Alignment _defaultAlignment = Alignment.topRight;

  /// نمایش Toast موفقیت‌آمیز
  static ToastificationItem success({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
    VoidCallback? onTap,
    ToastificationStyle style = ToastificationStyle.fillColored,
  }) {
    return Toastification.show(
      type: ToastificationType.success,
      style: style,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: alignment ?? _defaultAlignment,
      autoCloseDuration: duration ?? _defaultDuration,
      showProgressBar: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: onTap != null ? (_) => onTap() : null,
      ),
    );
  }

  /// نمایش Toast خطا
  static ToastificationItem error({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
    VoidCallback? onTap,
    ToastificationStyle style = ToastificationStyle.fillColored,
  }) {
    return Toastification.show(
      type: ToastificationType.error,
      style: style,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: alignment ?? _defaultAlignment,
      autoCloseDuration: duration ?? _defaultDuration,
      showProgressBar: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: onTap != null ? (_) => onTap() : null,
      ),
    );
  }

  /// نمایش Toast هشدار
  static ToastificationItem warning({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
    VoidCallback? onTap,
    ToastificationStyle style = ToastificationStyle.fillColored,
  }) {
    return Toastification.show(
      type: ToastificationType.warning,
      style: style,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: alignment ?? _defaultAlignment,
      autoCloseDuration: duration ?? _defaultDuration,
      showProgressBar: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: onTap != null ? (_) => onTap() : null,
      ),
    );
  }

  /// نمایش Toast اطلاعات
  static ToastificationItem info({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
    VoidCallback? onTap,
    ToastificationStyle style = ToastificationStyle.fillColored,
  }) {
    return Toastification.show(
      type: ToastificationType.info,
      style: style,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: alignment ?? _defaultAlignment,
      autoCloseDuration: duration ?? _defaultDuration,
      showProgressBar: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: onTap != null ? (_) => onTap() : null,
      ),
    );
  }

  /// نمایش Toast لودینگ
  static ToastificationItem loading({
    required String title,
    String? description,
    Alignment? alignment,
  }) {
    return Toastification.showCustom(
      alignment: alignment ?? _defaultAlignment,
      autoCloseDuration: null, // بدون بسته شدن خودکار
      builder: (context, item) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// نمایش Toast سفارشی با دکمه اکشن
  static ToastificationItem withAction({
    required String title,
    String? description,
    required String actionText,
    required VoidCallback onActionPressed,
    ToastificationType type = ToastificationType.info,
    Duration? duration,
    Alignment? alignment,
  }) {
    return Toastification.showCustom(
      alignment: alignment ?? _defaultAlignment,
      autoCloseDuration: duration ?? _defaultDuration,
      builder: (context, item) {
        Color bgColor;
        Color textColor = Colors.white;

        switch (type) {
          case ToastificationType.success:
            bgColor = Colors.green;
            break;
          case ToastificationType.error:
            bgColor = Colors.red;
            break;
          case ToastificationType.warning:
            bgColor = Colors.orange;
            break;
          case ToastificationType.info:
          default:
            bgColor = Colors.blue;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: textColor.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  onActionPressed();
                  Toastification().dismiss(item);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: textColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Text(actionText),
              ),
            ],
          ),
        );
      },
    );
  }

  /// بستن همه Toast ها
  static void dismissAll() {
    Toastification().dismissAll();
  }

  /// بستن Toast با ID
  static void dismissById(String id) {
    Toastification().dismissById(id);
  }

  /// بستن یک Toast خاص
  static void dismiss(ToastificationItem item) {
    Toastification().dismiss(item);
  }
}

// ============== مثال استفاده ==============
/*

// Toast موفقیت
CustomToast.success(
  title: 'عملیات موفق',
  description: 'اطلاعات با موفقیت ذخیره شد',
);

// Toast خطا
CustomToast.error(
  title: 'خطا',
  description: 'مشکلی در اتصال به سرور پیش آمد',
  duration: Duration(seconds: 5),
);

// Toast هشدار
CustomToast.warning(
  title: 'هشدار',
  description: 'لطفا فیلدهای الزامی را پر کنید',
);

// Toast اطلاعات
CustomToast.info(
  title: 'اطلاعات',
  description: 'نسخه جدید در دسترس است',
);

// Toast لودینگ
final loadingToast = CustomToast.loading(
  title: 'در حال بارگذاری...',
  description: 'لطفا صبر کنید',
);

// بستن Toast لودینگ بعد از اتمام عملیات
await someAsyncOperation();
CustomToast.dismiss(loadingToast);

// Toast با دکمه اکشن
CustomToast.withAction(
  title: 'پیام جدید',
  description: 'یک پیام از احمد دریافت کردید',
  actionText: 'مشاهده',
  onActionPressed: () {
    // باز کردن صفحه پیام
    print('دکمه مشاهده کلیک شد');
  },
  type: ToastificationType.info,
);

// تنظیم موقعیت نمایش
CustomToast.success(
  title: 'موفق',
  alignment: Alignment.bottomCenter,
);

// تنظیم زمان نمایش
CustomToast.error(
  title: 'خطا',
  duration: Duration(seconds: 10),
);

// بستن همه Toast ها
CustomToast.dismissAll();

*/