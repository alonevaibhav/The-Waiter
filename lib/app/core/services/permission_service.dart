// ============================================================================
// PERMISSION SERVICE - Updated for MaterialApp.router
// ============================================================================

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../Utils/snakbar_util.dart';
import '../theme/app_theme.dart';



class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  // ============================================================================
  // CAMERA PERMISSION
  // ============================================================================

  /// Check camera permission status
  Future<PermissionStatus> checkCameraPermission() async {
    return await Permission.camera.status;
  }

  /// Request camera permission with rationale
  Future<bool> requestCameraPermission({
    required BuildContext context,
    String? rationaleMessage,
    bool showRationale = true,
  }) async {
    final status = await Permission.camera.status;

    // Already granted
    if (status.isGranted) {
      return true;
    }

    // Permanently denied - must open settings
    if (status.isPermanentlyDenied) {
      return await _showPermissionDeniedDialog(
        context: context,
        title: 'Camera Access Required',
        message: rationaleMessage ??
            'Camera access is needed to take photos. Please enable it in app settings.',
        permission: 'Camera',
      );
    }

    // Show rationale before requesting (first time)
    if (showRationale && status.isDenied) {
      final shouldRequest = await _showPermissionRationaleDialog(
        context: context,
        title: 'Camera Permission',
        message: rationaleMessage ??
            'We need camera access to let you take photos for your profile and documents.',
        icon: PhosphorIcons.camera(PhosphorIconsStyle.fill),
      );

      if (!shouldRequest) return false;
    }

    // Request permission
    final result = await Permission.camera.request();
    return result.isGranted;
  }

  // ============================================================================
  // GALLERY/PHOTOS PERMISSION
  // ============================================================================

  /// Check photo library permission status
  Future<PermissionStatus> checkPhotosPermission() async {
    return await Permission.photos.status;
  }

  /// Request photo library permission
  Future<bool> requestPhotosPermission({
    required BuildContext context,
    String? rationaleMessage,
    bool showRationale = true,
  }) async {
    final status = await Permission.photos.status;

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await _showPermissionDeniedDialog(
        context: context,
        title: 'Photo Library Access Required',
        message: rationaleMessage ??
            'Photo library access is needed to select images. Please enable it in app settings.',
        permission: 'Photos',
      );
    }

    if (showRationale && status.isDenied) {
      final shouldRequest = await _showPermissionRationaleDialog(
        context: context,
        title: 'Photo Library Permission',
        message: rationaleMessage ??
            'We need access to your photo library to let you select images.',
        icon: PhosphorIcons.image(PhosphorIconsStyle.fill),
      );

      if (!shouldRequest) return false;
    }

    final result = await Permission.photos.request();
    return result.isGranted || result.isLimited;
  }

  // ============================================================================
  // STORAGE PERMISSION (Android < 13)
  // ============================================================================

  /// Check storage permission status
  Future<PermissionStatus> checkStoragePermission() async {
    return await Permission.storage.status;
  }

  /// Request storage permission
  Future<bool> requestStoragePermission({
    required BuildContext context,
    String? rationaleMessage,
    bool showRationale = true,
  }) async {
    // For Android 13+, no storage permission needed
    if (await Permission.photos.status.isGranted) {
      return true;
    }

    final status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await _showPermissionDeniedDialog(
        context: context,
        title: 'Storage Access Required',
        message: rationaleMessage ??
            'Storage access is needed to save and access files. Please enable it in app settings.',
        permission: 'Storage',
      );
    }

    if (showRationale && status.isDenied) {
      final shouldRequest = await _showPermissionRationaleDialog(
        context: context,
        title: 'Storage Permission',
        message: rationaleMessage ??
            'We need storage access to save and load your files.',
        icon: PhosphorIcons.folder(PhosphorIconsStyle.fill),
      );

      if (!shouldRequest) return false;
    }

    final result = await Permission.storage.request();
    return result.isGranted;
  }

  // ============================================================================
  // MICROPHONE PERMISSION (for video recording)
  // ============================================================================

  /// Check microphone permission status
  Future<PermissionStatus> checkMicrophonePermission() async {
    return await Permission.microphone.status;
  }

  /// Request microphone permission
  Future<bool> requestMicrophonePermission({
    required BuildContext context,
    String? rationaleMessage,
    bool showRationale = true,
  }) async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await _showPermissionDeniedDialog(
        context: context,
        title: 'Microphone Access Required',
        message: rationaleMessage ??
            'Microphone access is needed to record videos with audio. Please enable it in app settings.',
        permission: 'Microphone',
      );
    }

    if (showRationale && status.isDenied) {
      final shouldRequest = await _showPermissionRationaleDialog(
        context: context,
        title: 'Microphone Permission',
        message: rationaleMessage ??
            'We need microphone access to record videos with audio.',
        icon: PhosphorIcons.microphone(PhosphorIconsStyle.fill),
      );

      if (!shouldRequest) return false;
    }

    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  // ============================================================================
  // GROUP PERMISSIONS (Camera + Microphone for video)
  // ============================================================================

  /// Request multiple permissions at once for video recording
  Future<bool> requestVideoPermissions({
    required BuildContext context,
    String? rationaleMessage,
  }) async {
    // Show rationale for video recording
    final shouldRequest = await _showPermissionRationaleDialog(
      context: context,
      title: 'Video Recording Permissions',
      message: rationaleMessage ??
          'To record videos, we need access to your camera and microphone.',
      icon: PhosphorIcons.videoCamera(PhosphorIconsStyle.fill),
    );

    if (!shouldRequest) return false;

    // Request both permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    final micGranted = statuses[Permission.microphone]?.isGranted ?? false;

    if (!cameraGranted || !micGranted) {
      if (context.mounted) {
        SnackBarUtil.showError(
          context,
          'Both camera and microphone permissions are needed for video recording.',
          title: 'Permissions Required',
        );
      }
      return false;
    }

    return true;
  }

  /// Request photo selection permissions (smart - handles Android versions)
  Future<bool> requestMediaPermissions({required BuildContext context}) async {
    // For Android 13+, request photos permission
    // For older Android, request storage permission
    if (await Permission.photos.status.isGranted) {
      return true;
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.storage,
    ].request();

    return statuses[Permission.photos]?.isGranted ??
        statuses[Permission.storage]?.isGranted ??
        false;
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Open app settings
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// Check if any permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  // ============================================================================
  // UI DIALOGS
  // ============================================================================

  /// Show permission rationale dialog (before requesting)
  Future<bool> _showPermissionRationaleDialog({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionRationaleDialog(
        title: title,
        message: message,
        icon: icon,
      ),
    ) ??
        false;
  }

  /// Show permission denied dialog (permanently denied)
  Future<bool> _showPermissionDeniedDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String permission,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDeniedDialog(
        title: title,
        message: message,
        permission: permission,
      ),
    ) ??
        false;
  }
}

// ============================================================================
// PERMISSION RATIONALE DIALOG
// ============================================================================

class PermissionRationaleDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const PermissionRationaleDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48.sp,
                color: AppTheme.primary,
              ),
            ),

            Gap(20.h),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            Gap(12.h),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            Gap(24.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(
                        color: isDark
                            ? AppTheme.darkSurfaceVariant
                            : AppTheme.surfaceVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                    child: Text(
                      'Not Now',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.textOnPrimary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Allow',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PERMISSION DENIED DIALOG (Permanently Denied)
// ============================================================================

class PermissionDeniedDialog extends StatelessWidget {
  final String title;
  final String message;
  final String permission;

  const PermissionDeniedDialog({
    super.key,
    required this.title,
    required this.message,
    required this.permission,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
                size: 48.sp,
                color: AppTheme.warning,
              ),
            ),

            Gap(20.h),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            Gap(12.h),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            Gap(24.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(
                        color: isDark
                            ? AppTheme.darkSurfaceVariant
                            : AppTheme.surfaceVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                      await openAppSettings();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.textOnPrimary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Open Settings',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}