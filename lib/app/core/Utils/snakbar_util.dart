
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
  custom,
}

class SnackBarUtil {
  // NEW show() METHOD - now returns controller
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
      BuildContext context,
      String message, {
        String? title,
        SnackBarType type = SnackBarType.info,
        Duration duration = const Duration(seconds: 2),
        IconData? icon,
        Color? backgroundColor,
        Color textColor = Colors.white,
        bool dismissible = true,
      }) {
    switch (type) {
      case SnackBarType.success:
        return showSuccess(context, message, title: title, duration: duration, dismissible: dismissible);

      case SnackBarType.error:
        return showError(context, message, title: title, duration: duration, dismissible: dismissible);

      case SnackBarType.warning:
        return showWarning(context, message, title: title, duration: duration, dismissible: dismissible);

      case SnackBarType.info:
        return showInfo(context, message, title: title, duration: duration, dismissible: dismissible);

      case SnackBarType.custom:
        return showCustom(
          context: context,
          message: message,
          title: title,
          icon: icon,
          backgroundColor: backgroundColor,
          textColor: textColor,
          duration: duration,
          dismissible: dismissible,
        );
    }
  }

  // EXISTING METHODS - now return controller ------------------------------------------

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccess(
      BuildContext context,
      String message, {
        String? title,
        Duration? duration,
        bool dismissible = true,
      }) {
    return _showSnackBar(
      context,
      message: message,
      title: title,
      icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
      backgroundColor: Colors.green.withOpacity(0.9),
      duration: duration ?? const Duration(seconds: 2),
      dismissible: dismissible,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
      BuildContext context,
      String message, {
        String? title,
        Duration? duration,
        bool dismissible = true,
      }) {
    return _showSnackBar(
      context,
      message: message,
      title: title,
      icon: PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
      backgroundColor: Colors.red.withOpacity(0.9),
      duration: duration ?? const Duration(seconds: 2),
      dismissible: dismissible,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showWarning(
      BuildContext context,
      String message, {
        String? title,
        Duration? duration,
        bool dismissible = true,
      }) {
    return _showSnackBar(
      context,
      message: message,
      title: title,
      icon: PhosphorIcons.warning(PhosphorIconsStyle.fill),
      backgroundColor: Colors.orange.withOpacity(0.9),
      duration: duration ?? const Duration(seconds: 2),
      dismissible: dismissible,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfo(
      BuildContext context,
      String message, {
        String? title,
        Duration? duration,
        bool dismissible = true,
      }) {
    return _showSnackBar(
      context,
      message: message,
      title: title,
      icon: PhosphorIcons.info(PhosphorIconsStyle.fill),
      backgroundColor: Colors.blue.withOpacity(0.9),
      duration: duration ?? const Duration(seconds: 2),
      dismissible: dismissible,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustom({
    required BuildContext context,
    required String message,
    String? title,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Duration? duration,
    bool dismissible = true,
  }) {
    return _showSnackBar(
      context,
      message: message,
      title: title,
      icon: icon,
      backgroundColor: backgroundColor ?? Colors.grey.withOpacity(0.9),
      textColor: textColor ?? Colors.white,
      duration: duration ?? const Duration(seconds: 2),
      dismissible: dismissible,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
      BuildContext context, {
        required String message,
        String? title,
        IconData? icon,
        required Color backgroundColor,
        Color textColor = Colors.white,
        required Duration duration,
        bool dismissible = true,
      }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) Icon(icon, color: textColor, size: 20.sp),
            if (icon != null) SizedBox(width: 8.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  Text(
                    message,
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        dismissDirection: dismissible ? DismissDirection.down : DismissDirection.none, // KEY CHANGE
      ),
    );
  }
}