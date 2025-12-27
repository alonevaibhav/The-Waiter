import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../core/Utils/customize_media_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../route/app_routes.dart';

class MediaPickerTestController extends GetxController {
  final uploadedImages = <String>[].obs;
  final uploadedDocuments = <String>[].obs;

  void pickCamera(BuildContext context) {
    ImagePickerUtil.showMediaPicker(
      context: context,
      title: 'Test Camera',
      onImagesSelected: uploadedImages.addAll,
      maxFileSize: 50,
    );
  }

  void pickGallery(BuildContext context) {
    ImagePickerUtil.showMediaPicker(
      context: context,
      title: 'Test Gallery',
      onImagesSelected: uploadedImages.addAll,
      maxFileSize: 50,
    );
  }

  void pickDocument(BuildContext context) {
    ImagePickerUtil.showMediaPicker(
      context: context,
      title: 'Test Document Picker',
      onDocumentsSelected: uploadedDocuments.addAll,
      maxFileSize: 50,
    );
  }

  void clearImages() => uploadedImages.clear();

  void clearDocuments() => uploadedDocuments.clear();
}



class IntegratedPermissionDemoScreen extends GetView<MediaPickerTestController> {
  const IntegratedPermissionDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MediaPickerTestController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.primaryLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => NavigationService.goBack(),
          icon: Icon(
            PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textOnPrimary,
            size: 24.sp,
          ),
        ),
        title: Text(
          'ImagePickerUtil Test',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(theme, isDark),
            Gap(AppTheme.space24),

            _buildSectionHeader(
              theme,
              isDark,
              'Test Media Pickers',
              PhosphorIcons.testTube(PhosphorIconsStyle.fill),
            ),
            Gap(AppTheme.space12),

            _buildTestActionCard(
              theme,
              isDark,
              title: 'Test Camera',
              description: 'Opens camera to take photo',
              icon: PhosphorIcons.camera(PhosphorIconsStyle.fill),
              color: AppTheme.secondary,
              onTap: () => controller.pickCamera(context),
            ),
            Gap(AppTheme.space12),

            _buildTestActionCard(
              theme,
              isDark,
              title: 'Test Photo Gallery',
              description: 'Opens gallery to select images',
              icon: PhosphorIcons.image(PhosphorIconsStyle.fill),
              color: AppTheme.accent,
              onTap: () => controller.pickGallery(context),
            ),
            Gap(AppTheme.space12),

            _buildTestActionCard(
              theme,
              isDark,
              title: 'Test Document Picker',
              description: 'Opens document picker',
              icon: PhosphorIcons.file(PhosphorIconsStyle.fill),
              color: AppTheme.warning,
              onTap: () => controller.pickDocument(context),
            ),

            Gap(AppTheme.space24),

            Obx(() {
              final hasFiles = controller.uploadedImages.isNotEmpty ||
                  controller.uploadedDocuments.isNotEmpty;
              if (!hasFiles) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    theme,
                    isDark,
                    'Uploaded Files',
                    PhosphorIcons.files(PhosphorIconsStyle.fill),
                  ),
                  Gap(AppTheme.space12),

                  if (controller.uploadedImages.isNotEmpty)
                    _buildUploadedFilesCard(
                      theme,
                      isDark,
                      title: 'Images',
                      files: controller.uploadedImages,
                      icon: PhosphorIcons.image(PhosphorIconsStyle.fill),
                      onClear: controller.clearImages,
                    ),

                  if (controller.uploadedImages.isNotEmpty &&
                      controller.uploadedDocuments.isNotEmpty)
                    Gap(AppTheme.space12),

                  if (controller.uploadedDocuments.isNotEmpty)
                    _buildUploadedFilesCard(
                      theme,
                      isDark,
                      title: 'Documents',
                      files: controller.uploadedDocuments,
                      icon: PhosphorIcons.file(PhosphorIconsStyle.fill),
                      onClear: controller.clearDocuments,
                    ),

                  Gap(40.h),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.primaryLight.withOpacity(0.1)
            : AppTheme.primaryLight.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.primaryLight.withOpacity(0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppTheme.space12),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              PhosphorIcons.info(PhosphorIconsStyle.fill),
              color: AppTheme.primaryLight,
              size: 24.sp,
            ),
          ),
          Gap(AppTheme.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ImagePickerUtil Testing',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(AppTheme.space4),
                Text(
                  'Test camera, gallery, and document picker functionality with ImagePickerUtil.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, bool isDark, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppTheme.space8),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryLight,
            size: 20.sp,
          ),
        ),
        Gap(AppTheme.space12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTestActionCard(
      ThemeData theme,
      bool isDark, {
        required String title,
        required String description,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        padding: EdgeInsets.all(AppTheme.space16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5.w,
          ),
          boxShadow: isDark ? AppTheme.darkShadowSmall : AppTheme.shadowSmall,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppTheme.space12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24.sp,
              ),
            ),
            Gap(AppTheme.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                    ),
                  ),
                  Gap(AppTheme.space4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
              color: color,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadedFilesCard(
      ThemeData theme,
      bool isDark, {
        required String title,
        required RxList<String> files,
        required IconData icon,
        required VoidCallback onClear,
      }) {
    return Container(
      padding: EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.success.withOpacity(0.3),
          width: 1.5.w,
        ),
        boxShadow: isDark ? AppTheme.darkShadowSmall : AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.space8),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.success,
                  size: 18.sp,
                ),
              ),
              Gap(AppTheme.space8),
              Text(
                '$title (${files.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onClear,
                icon: Icon(
                  PhosphorIcons.trash(PhosphorIconsStyle.regular),
                  color: AppTheme.error,
                  size: 20.sp,
                ),
                padding: EdgeInsets.all(AppTheme.space8),
                constraints: const BoxConstraints(),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.error.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                ),
              ),
            ],
          ),
          Gap(AppTheme.space12),
          ...files.map((filePath) {
            final fileName = filePath.split('/').last;
            return Container(
              margin: EdgeInsets.only(bottom: AppTheme.space8),
              padding: EdgeInsets.all(AppTheme.space12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                    color: AppTheme.success,
                    size: 16.sp,
                  ),
                  Gap(AppTheme.space8),
                  Expanded(
                    child: Text(
                      fileName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}