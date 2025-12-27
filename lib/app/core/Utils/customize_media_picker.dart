// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';
// import '../theme/app_theme.dart';
//
// class ImagePickerUtil {
//   static const double sizeFactor = 0.75;
//
//   /// Build File Upload Field - Using AppTheme text styles
//   static Widget buildFileUploadField({
//     required BuildContext context,
//     required String label,
//     required String hint,
//     required IconData icon,
//     required RxList<String> uploadedFiles,
//     required Function(List<String>) onFilesSelected,
//     bool isRequired = false,
//   }) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Obx(() => Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Label - using titleLarge
//         Text(
//           label,
//           style: textTheme.titleLarge?.copyWith(
//             color: AppTheme.textPrimary,
//           ),
//         ),
//         Gap(8.h * sizeFactor),
//
//         // Upload Button
//         _buildUploadButton(
//           context: context,
//           icon: icon,
//           hint: hint,
//           uploadedFiles: uploadedFiles,
//           onTap: () => _showFileUploadDialog(
//             onFilesSelected: onFilesSelected,
//           ),
//         ),
//
//         // Show uploaded files list
//         if (uploadedFiles.isNotEmpty) ...[
//           Gap(12.h * sizeFactor),
//           _buildUploadedFilesList(context, uploadedFiles),
//         ],
//       ],
//     ));
//   }
//
//   /// Build Section Header - Using AppTheme
//   static Widget buildSectionHeader({
//     required BuildContext context,
//     required String title,
//     required IconData icon,
//   }) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 16.w * sizeFactor,
//         vertical: 12.h * sizeFactor,
//       ),
//       decoration: BoxDecoration(
//         color: AppTheme.primaryLight.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8.r * sizeFactor),
//         border: Border.all(color: AppTheme.primaryLight.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: AppTheme.primaryLight,
//             size: 20.sp * sizeFactor,
//           ),
//           Gap(8.w * sizeFactor),
//           Text(
//             title,
//             style: textTheme.titleLarge?.copyWith(
//               color: AppTheme.primaryLight,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ===== PRIVATE HELPER METHODS =====
//
//   /// Build Upload Button - Using Theme textStyles
//   static Widget _buildUploadButton({
//     required BuildContext context,
//     required IconData icon,
//     required String hint,
//     required RxList<String> uploadedFiles,
//     required VoidCallback onTap,
//   }) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12.r * sizeFactor),
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(
//           horizontal: 16.w * sizeFactor,
//           vertical: 16.h * sizeFactor,
//         ),
//         decoration: BoxDecoration(
//           color: AppTheme.background,
//           borderRadius: BorderRadius.circular(12.r * sizeFactor),
//           border: Border.all(
//             color: uploadedFiles.isEmpty
//                 ? AppTheme.textTertiary.withOpacity(0.3)
//                 : AppTheme.primaryLight.withOpacity(0.5),
//             width: uploadedFiles.isEmpty ? 1 : 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: AppTheme.primaryLight,
//               size: 20.w * sizeFactor,
//             ),
//             Gap(12.w * sizeFactor),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     uploadedFiles.isEmpty
//                         ? hint
//                         : '${uploadedFiles.length} file${uploadedFiles.length > 1 ? 's' : ''} selected',
//                     style: textTheme.titleLarge?.copyWith(
//                       color: uploadedFiles.isEmpty
//                           ? AppTheme.textSecondary
//                           : AppTheme.primaryLight,
//                       fontWeight: uploadedFiles.isEmpty
//                           ? FontWeight.w400
//                           : FontWeight.w600,
//                     ),
//                   ),
//                   if (uploadedFiles.isNotEmpty) ...[
//                     Gap(4.h * sizeFactor),
//                     Text(
//                       'Tap to change files',
//                       style: textTheme.titleSmall?.copyWith(
//                         color: AppTheme.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             Icon(
//               uploadedFiles.isEmpty
//                   ? PhosphorIcons.plus(PhosphorIconsStyle.regular)
//                   : PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
//               color: uploadedFiles.isEmpty
//                   ? AppTheme.textSecondary
//                   : AppTheme.primaryLight,
//               size: 20.w * sizeFactor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Build Uploaded Files List - Using Theme textStyles
//   static Widget _buildUploadedFilesList(BuildContext context, RxList<String> uploadedFiles) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       padding: EdgeInsets.all(12.w * sizeFactor),
//       decoration: BoxDecoration(
//         color: AppTheme.primaryLight.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8.r * sizeFactor),
//         border: Border.all(color: AppTheme.primaryLight.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 PhosphorIcons.files(PhosphorIconsStyle.regular),
//                 color: AppTheme.primaryLight,
//                 size: 16.w * sizeFactor,
//               ),
//               Gap(8.w * sizeFactor),
//               Text(
//                 'Uploaded Files',
//                 style: textTheme.titleMedium?.copyWith(
//                   color: AppTheme.primaryLight,
//                 ),
//               ),
//               const Spacer(),
//               InkWell(
//                 onTap: () => uploadedFiles.clear(),
//                 child: Container(
//                   padding: EdgeInsets.all(4.w * sizeFactor),
//                   child: Icon(
//                     PhosphorIcons.trash(PhosphorIconsStyle.regular),
//                     color: AppTheme.error,
//                     size: 16.w * sizeFactor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Gap(8.h * sizeFactor),
//           ...uploadedFiles.map((filePath) => _buildFileItem(context, filePath)).toList(),
//         ],
//       ),
//     );
//   }
//
//   /// Build File Item - Using Theme textStyles
//   static Widget _buildFileItem(BuildContext context, String filePath) {
//     final fileName = filePath.split('/').last;
//     final isImage = _isImageFile(fileName);
//     final textTheme = Theme.of(context).textTheme;
//
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8.h * sizeFactor),
//       child: Row(
//         children: [
//           Icon(
//             isImage
//                 ? PhosphorIcons.image(PhosphorIconsStyle.regular)
//                 : PhosphorIcons.file(PhosphorIconsStyle.regular),
//             color: AppTheme.textSecondary,
//             size: 16.w * sizeFactor,
//           ),
//           Gap(8.w * sizeFactor),
//           Expanded(
//             child: Text(
//               fileName,
//               style: textTheme.titleSmall?.copyWith(
//                 color: AppTheme.textSecondary,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Check if file is image
//   static bool _isImageFile(String fileName) {
//     final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
//     final extension = fileName.split('.').last.toLowerCase();
//     return imageExtensions.contains(extension);
//   }
//
//   /// Show File Upload Dialog
//   static void _showFileUploadDialog({
//     required Function(List<String>) onFilesSelected,
//   }) {
//     showMediaPicker(
//       context: Get.context!,
//       title: 'Select Files',
//       onImagesSelected: (imagePaths) {
//         onFilesSelected(imagePaths);
//       },
//       onDocumentsSelected: (documentPaths) {
//         onFilesSelected(documentPaths);
//       },
//       maxFileSize: 50,
//     );
//   }
//
//   /// Show Media Picker Bottom Sheet
//   static Future<void> showMediaPicker({
//     required BuildContext context,
//     Function(List<String> imagePaths)? onImagesSelected,
//     Function(List<String> documentPaths)? onDocumentsSelected,
//     String title = 'Upload Media',
//     int? maxFileSize = 50,
//   }) async {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => _buildMediaPickerSheet(
//         context: context,
//         onImagesSelected: onImagesSelected,
//         onDocumentsSelected: onDocumentsSelected,
//         title: title,
//         maxFileSize: maxFileSize,
//       ),
//     );
//   }
//
//   /// Media Picker Bottom Sheet UI
//   static Widget _buildMediaPickerSheet({
//     required BuildContext context,
//     Function(List<String> imagePaths)? onImagesSelected,
//     Function(List<String> documentPaths)? onDocumentsSelected,
//     String title = 'Upload Media',
//     int? maxFileSize = 50,
//   }) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height * 0.6,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24.r * sizeFactor)),
//         boxShadow: [
//           BoxShadow(
//             color: AppTheme.primaryLight.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle bar
//           Container(
//             margin: EdgeInsets.only(top: 12.h * sizeFactor),
//             width: 40.w * sizeFactor,
//             height: 4.h * sizeFactor,
//             decoration: BoxDecoration(
//               color: AppTheme.textTertiary.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(2.r * sizeFactor),
//             ),
//           ),
//
//           // Header
//           Container(
//             padding: EdgeInsets.all(20.w * sizeFactor),
//             child: Row(
//               children: [
//                 Icon(
//                   PhosphorIcons.upload(PhosphorIconsStyle.fill),
//                   color: AppTheme.primaryLight,
//                   size: 24.w * sizeFactor,
//                 ),
//                 Gap(12.w * sizeFactor),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: textTheme.headlineMedium?.copyWith(
//                       color: AppTheme.textPrimary,
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () => Navigator.of(context).pop(),
//                   borderRadius: BorderRadius.circular(20.r * sizeFactor),
//                   child: Container(
//                     padding: EdgeInsets.all(8.w * sizeFactor),
//                     child: Icon(
//                       Icons.close,
//                       color: AppTheme.textSecondary,
//                       size: 20.w * sizeFactor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Content
//           Flexible(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 20.w * sizeFactor),
//               child: Column(
//                 children: [
//                   // Photos Section
//                   _buildSectionHeader(context, 'Photos', PhosphorIcons.camera(PhosphorIconsStyle.fill)),
//                   Gap(12.h * sizeFactor),
//
//                   _buildMediaOptionTile(
//                     context: context,
//                     icon: PhosphorIcons.camera(PhosphorIconsStyle.fill),
//                     title: 'Take Photo',
//                     subtitle: 'Capture a new photo',
//                     onTap: () => _pickImage(context, ImageSource.camera, onImagesSelected),
//                   ),
//
//                   Gap(8.h * sizeFactor),
//
//                   _buildMediaOptionTile(
//                     context: context,
//                     icon: PhosphorIcons.image(PhosphorIconsStyle.fill),
//                     title: 'Photo Gallery',
//                     subtitle: 'Choose from gallery',
//                     onTap: () => _pickImage(context, ImageSource.gallery, onImagesSelected),
//                   ),
//
//                   Gap(24.h * sizeFactor),
//
//                   // Documents Section
//                   _buildSectionHeader(context, 'Documents', PhosphorIcons.fileText(PhosphorIconsStyle.fill)),
//                   Gap(12.h * sizeFactor),
//
//                   _buildMediaOptionTile(
//                     context: context,
//                     icon: PhosphorIcons.filePdf(PhosphorIconsStyle.fill),
//                     title: 'PDF Files',
//                     subtitle: 'Select PDF documents',
//                     iconColor: Colors.red.shade600,
//                     onTap: () => _pickDocuments(context, ['pdf'], onDocumentsSelected, maxFileSize),
//                   ),
//
//                   Gap(8.h * sizeFactor),
//
//                   _buildMediaOptionTile(
//                     context: context,
//                     icon: PhosphorIcons.fileDoc(PhosphorIconsStyle.fill),
//                     title: 'Word Documents',
//                     subtitle: 'DOC, DOCX files',
//                     iconColor: Colors.blue.shade600,
//                     onTap: () => _pickDocuments(context, ['doc', 'docx'], onDocumentsSelected, maxFileSize),
//                   ),
//
//                   Gap(24.h * sizeFactor),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Section Header for Media Picker
//   static Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Row(
//       children: [
//         Container(
//           padding: EdgeInsets.all(8.w * sizeFactor),
//           decoration: BoxDecoration(
//             color: AppTheme.primaryLight.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8.r * sizeFactor),
//           ),
//           child: Icon(icon, color: AppTheme.primaryLight, size: 20.w * sizeFactor),
//         ),
//         Gap(12.w * sizeFactor),
//         Text(
//           title,
//           style: textTheme.titleLarge?.copyWith(
//             color: AppTheme.primaryLight,
//           ),
//         ),
//         Expanded(
//           child: Container(
//             height: 1.h * sizeFactor,
//             margin: EdgeInsets.only(left: 12.w * sizeFactor),
//             color: AppTheme.primaryLight.withOpacity(0.2),
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Media Option Tile
//   static Widget _buildMediaOptionTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     Color? iconColor,
//   }) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.r * sizeFactor),
//         border: Border.all(color: AppTheme.textTertiary.withOpacity(0.3)),
//         color: AppTheme.background,
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12.r * sizeFactor),
//         onTap: onTap,
//         child: Padding(
//           padding: EdgeInsets.all(16.w * sizeFactor),
//           child: Row(
//             children: [
//               Container(
//                 width: 48.w * sizeFactor,
//                 height: 48.h * sizeFactor,
//                 decoration: BoxDecoration(
//                   color: (iconColor ?? AppTheme.primaryLight).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12.r * sizeFactor),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: iconColor ?? AppTheme.primaryLight,
//                   size: 24.w * sizeFactor,
//                 ),
//               ),
//               Gap(16.w * sizeFactor),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: textTheme.titleLarge?.copyWith(
//                         color: AppTheme.textPrimary,
//                       ),
//                     ),
//                     Gap(4.h * sizeFactor),
//                     Text(
//                       subtitle,
//                       style: textTheme.titleMedium?.copyWith(
//                         color: AppTheme.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 PhosphorIcons.caretRight(PhosphorIconsStyle.regular),
//                 size: 16.w * sizeFactor,
//                 color: AppTheme.textSecondary,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Pick Single Image
//   static Future<void> _pickImage(
//       BuildContext context,
//       ImageSource source,
//       Function(List<String> imagePaths)? onImagesSelected,
//       ) async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: source,
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
//
//       if (image != null) {
//         Navigator.of(context).pop();
//         onImagesSelected?.call([image.path]);
//         _showSuccessMessage('Photo added successfully');
//       }
//     } catch (e) {
//       _showErrorMessage('Failed to pick image: $e');
//     }
//   }
//
//   /// Pick Documents
//   static Future<void> _pickDocuments(
//       BuildContext context,
//       List<String> allowedExtensions,
//       Function(List<String> documentPaths)? onDocumentsSelected,
//       int? maxFileSize,
//       ) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: allowedExtensions,
//         allowMultiple: true,
//       );
//
//       if (result != null) {
//         List<String> filePaths = result.paths.where((path) => path != null).cast<String>().toList();
//
//         // Check file sizes
//         if (maxFileSize != null) {
//           for (String path in filePaths) {
//             final file = File(path);
//             final fileSize = await file.length();
//             if (fileSize > (maxFileSize * 1024 * 1024)) {
//               _showErrorMessage('Some files exceed the ${maxFileSize}MB limit');
//               return;
//             }
//           }
//         }
//
//         if (filePaths.isNotEmpty) {
//           Navigator.of(context).pop();
//           onDocumentsSelected?.call(filePaths);
//           _showSuccessMessage('${filePaths.length} ${filePaths.length == 1 ? 'document' : 'documents'} added successfully');
//         }
//       }
//     } catch (e) {
//       _showErrorMessage('Failed to pick documents: $e');
//     }
//   }
//
//   /// Show Success Message
//   static void _showSuccessMessage(String message) {
//     Get.snackbar(
//       'Success',
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: AppTheme.primaryLight,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//       margin: EdgeInsets.all(16.w * sizeFactor),
//       borderRadius: 12.r * sizeFactor,
//       icon: Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: Colors.white),
//     );
//   }
//
//   /// Show Error Message
//   static void _showErrorMessage(String message) {
//     Get.snackbar(
//       'Error',
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: AppTheme.error,
//       colorText: Colors.white,
//       margin: EdgeInsets.all(16.w * sizeFactor),
//       borderRadius: 12.r * sizeFactor,
//       icon: Icon(PhosphorIcons.warning(PhosphorIconsStyle.fill), color: Colors.white),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:the_waiter/app/core/Utils/snakbar_util.dart';
import 'dart:io';
import '../services/permission_service.dart';
import '../theme/app_theme.dart';

class ImagePickerUtil {
  static const double sizeFactor = 0.75;
  static final _permissionService = PermissionService();

  /// Build File Upload Field - Theme Aware
  static Widget buildFileUploadField({
    required BuildContext context,
    required String label,
    required String hint,
    required IconData icon,
    required RxList<String> uploadedFiles,
    required Function(List<String>) onFilesSelected,
    bool isRequired = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: textTheme.titleLarge?.copyWith(
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
          ),
        ),
        Gap(8.h * sizeFactor),

        // Upload Button
        _buildUploadButton(
          context: context,
          icon: icon,
          hint: hint,
          uploadedFiles: uploadedFiles,
          onTap: () => _showFileUploadDialog(
            context: context,
            onFilesSelected: onFilesSelected,
          ),
        ),

        // Show uploaded files list
        if (uploadedFiles.isNotEmpty) ...[
          Gap(12.h * sizeFactor),
          _buildUploadedFilesList(context, uploadedFiles),
        ],
      ],
    ));
  }

  /// Build Section Header - Theme Aware
  static Widget buildSectionHeader({
    required BuildContext context,
    required String title,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w * sizeFactor,
        vertical: 12.h * sizeFactor,
      ),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.primaryLight : AppTheme.primaryLight).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r * sizeFactor),
        border: Border.all(
          color: (isDark ? AppTheme.primaryLight : AppTheme.primaryLight).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? AppTheme.primaryLight : AppTheme.primaryLight,
            size: 20.sp * sizeFactor,
          ),
          Gap(8.w * sizeFactor),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: isDark ? AppTheme.primaryLight : AppTheme.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  // ===== PRIVATE HELPER METHODS =====

  /// Build Upload Button - Theme Aware
  static Widget _buildUploadButton({
    required BuildContext context,
    required IconData icon,
    required String hint,
    required RxList<String> uploadedFiles,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r * sizeFactor),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w * sizeFactor,
          vertical: 16.h * sizeFactor,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.background,
          borderRadius: BorderRadius.circular(12.r * sizeFactor),
          border: Border.all(
            color: uploadedFiles.isEmpty
                ? (isDark ? AppTheme.darkTextTertiary : AppTheme.textTertiary).withOpacity(0.3)
                : (isDark ? AppTheme.primaryLight : AppTheme.primaryLight).withOpacity(0.5),
            width: uploadedFiles.isEmpty ? 1 : 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? AppTheme.primaryLight : AppTheme.primaryLight,
              size: 20.w * sizeFactor,
            ),
            Gap(12.w * sizeFactor),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    uploadedFiles.isEmpty
                        ? hint
                        : '${uploadedFiles.length} file${uploadedFiles.length > 1 ? 's' : ''} selected',
                    style: textTheme.titleLarge?.copyWith(
                      color: uploadedFiles.isEmpty
                          ? (isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)
                          : (isDark ? AppTheme.primaryLight : AppTheme.primaryLight),
                      fontWeight: uploadedFiles.isEmpty
                          ? FontWeight.w400
                          : FontWeight.w600,
                    ),
                  ),
                  if (uploadedFiles.isNotEmpty) ...[
                    Gap(4.h * sizeFactor),
                    Text(
                      'Tap to change files',
                      style: textTheme.titleSmall?.copyWith(
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              uploadedFiles.isEmpty
                  ? PhosphorIcons.plus(PhosphorIconsStyle.regular)
                  : PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
              color: uploadedFiles.isEmpty
                  ? (isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)
                  : (isDark ? AppTheme.primaryLight : AppTheme.primaryLight),
              size: 20.w * sizeFactor,
            ),
          ],
        ),
      ),
    );
  }

  /// Build Uploaded Files List - Theme Aware
  static Widget _buildUploadedFilesList(BuildContext context, RxList<String> uploadedFiles) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(12.w * sizeFactor),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.primaryLight : AppTheme.primaryLight).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r * sizeFactor),
        border: Border.all(
          color: (isDark ? AppTheme.primaryLight : AppTheme.primaryLight).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.files(PhosphorIconsStyle.regular),
                color: isDark ? AppTheme.primaryLight : AppTheme.primaryLight,
                size: 16.w * sizeFactor,
              ),
              Gap(8.w * sizeFactor),
              Text(
                'Uploaded Files',
                style: textTheme.titleMedium?.copyWith(
                  color: isDark ? AppTheme.primaryLight : AppTheme.primaryLight,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => uploadedFiles.clear(),
                child: Container(
                  padding: EdgeInsets.all(4.w * sizeFactor),
                  child: Icon(
                    PhosphorIcons.trash(PhosphorIconsStyle.regular),
                    color: AppTheme.error,
                    size: 16.w * sizeFactor,
                  ),
                ),
              ),
            ],
          ),
          Gap(8.h * sizeFactor),
          ...uploadedFiles.map((filePath) => _buildFileItem(context, filePath)).toList(),
        ],
      ),
    );
  }

  /// Build File Item - Theme Aware
  static Widget _buildFileItem(BuildContext context, String filePath) {
    final fileName = filePath.split('/').last;
    final isImage = _isImageFile(fileName);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h * sizeFactor),
      child: Row(
        children: [
          Icon(
            isImage
                ? PhosphorIcons.image(PhosphorIconsStyle.regular)
                : PhosphorIcons.file(PhosphorIconsStyle.regular),
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
            size: 16.w * sizeFactor,
          ),
          Gap(8.w * sizeFactor),
          Expanded(
            child: Text(
              fileName,
              style: textTheme.titleSmall?.copyWith(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Check if file is image
  static bool _isImageFile(String fileName) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    final extension = fileName.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  /// Show File Upload Dialog
  static void _showFileUploadDialog({
    required BuildContext context,
    required Function(List<String>) onFilesSelected,
  }) {
    showMediaPicker(
      context: context,
      title: 'Select Files',
      onImagesSelected: (imagePaths) {
        onFilesSelected(imagePaths);
      },
      onDocumentsSelected: (documentPaths) {
        onFilesSelected(documentPaths);
      },
      maxFileSize: 50,
    );
  }

  /// Show Media Picker Bottom Sheet
  static Future<void> showMediaPicker({
    required BuildContext context,
    Function(List<String> imagePaths)? onImagesSelected,
    Function(List<String> documentPaths)? onDocumentsSelected,
    String title = 'Upload Media',
    int? maxFileSize = 50,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMediaPickerSheet(
        context: context,
        onImagesSelected: onImagesSelected,
        onDocumentsSelected: onDocumentsSelected,
        title: title,
        maxFileSize: maxFileSize,
      ),
    );
  }

  /// Media Picker Bottom Sheet UI - Theme Aware
  static Widget _buildMediaPickerSheet({
    required BuildContext context,
    Function(List<String> imagePaths)? onImagesSelected,
    Function(List<String> documentPaths)? onDocumentsSelected,
    String title = 'Upload Media',
    int? maxFileSize = 50,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r * sizeFactor)),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppTheme.primaryLight : AppTheme.primaryLight).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8.h * sizeFactor),
            width: 36.w * sizeFactor,
            height: 4.h * sizeFactor,
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.darkTextTertiary : AppTheme.textTertiary).withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r * sizeFactor),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(16.w * sizeFactor),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.upload(PhosphorIconsStyle.fill),
                  color: isDark ? AppTheme.primaryLight : AppTheme.primaryLight,
                  size: 20.w * sizeFactor,
                ),
                Gap(10.w * sizeFactor),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(16.r * sizeFactor),
                  child: Container(
                    padding: EdgeInsets.all(6.w * sizeFactor),
                    child: Icon(
                      Icons.close,
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                      size: 18.w * sizeFactor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w * sizeFactor),
              child: Column(
                children: [
                  // Photos Section
                  _buildSectionHeader(context, 'Photos', PhosphorIcons.camera(PhosphorIconsStyle.fill)),
                  Gap(8.h * sizeFactor),

                  _buildMediaOptionTile(
                    context: context,
                    icon: PhosphorIcons.camera(PhosphorIconsStyle.fill),
                    title: 'Take Photo',
                    subtitle: 'Capture a new photo',
                    onTap: () => _pickImage(context, ImageSource.camera, onImagesSelected),
                  ),

                  Gap(6.h * sizeFactor),

                  _buildMediaOptionTile(
                    context: context,
                    icon: PhosphorIcons.image(PhosphorIconsStyle.fill),
                    title: 'Photo Gallery',
                    subtitle: 'Choose from gallery',
                    onTap: () => _pickImage(context, ImageSource.gallery, onImagesSelected),
                  ),

                  Gap(16.h * sizeFactor),

                  // Documents Section
                  _buildSectionHeader(context, 'Documents', PhosphorIcons.fileText(PhosphorIconsStyle.fill)),
                  Gap(8.h * sizeFactor),

                  _buildMediaOptionTile(
                    context: context,
                    icon: PhosphorIcons.filePdf(PhosphorIconsStyle.fill),
                    title: 'PDF Files',
                    subtitle: 'Select PDF documents',
                    iconColor: Colors.red.shade600,
                    onTap: () => _pickDocuments(context, ['pdf'], onDocumentsSelected, maxFileSize),
                  ),

                  Gap(6.h * sizeFactor),

                  _buildMediaOptionTile(
                    context: context,
                    icon: PhosphorIcons.fileDoc(PhosphorIconsStyle.fill),
                    title: 'Word Documents',
                    subtitle: 'DOC, DOCX files',
                    iconColor: Colors.blue.shade600,
                    onTap: () => _pickDocuments(context, ['doc', 'docx'], onDocumentsSelected, maxFileSize),
                  ),

                  Gap(16.h * sizeFactor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Header for Media Picker - Theme Aware
  static Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w * sizeFactor),
          decoration: BoxDecoration(
            color: (isDark ? AppTheme.primaryLight : AppTheme.primaryLight).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r * sizeFactor),
          ),
          child: Icon(
            icon,
            color: isDark ? AppTheme.primaryLight : AppTheme.primaryLight,
            size: 18.w * sizeFactor,
          ),
        ),
        Gap(10.w * sizeFactor),
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: isDark ? AppTheme.primaryLight : AppTheme.primaryLight,
          ),
        ),
        Expanded(
          child: Container(
            height: 1.h * sizeFactor,
            margin: EdgeInsets.only(left: 10.w * sizeFactor),
            color: (isDark ? AppTheme.primaryLight : AppTheme.primaryLight).withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  /// Media Option Tile - Theme Aware
  static Widget _buildMediaOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(
          color: (isDark ? AppTheme.darkTextTertiary : AppTheme.textTertiary).withOpacity(0.3),
        ),
        color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.background,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.w * sizeFactor),
          child: Row(
            children: [
              Container(
                width: 40.w * sizeFactor,
                height: 40.h * sizeFactor,
                decoration: BoxDecoration(
                  color: (iconColor ?? (isDark ? AppTheme.primaryLight : AppTheme.primaryLight)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r * sizeFactor),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? (isDark ? AppTheme.primaryLight : AppTheme.primaryLight),
                  size: 20.w * sizeFactor,
                ),
              ),
              Gap(12.w * sizeFactor),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                      ),
                    ),
                    Gap(2.h * sizeFactor),
                    Text(
                      subtitle,
                      style: textTheme.labelSmall?.copyWith(
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                PhosphorIcons.caretRight(PhosphorIconsStyle.regular),
                size: 14.w * sizeFactor,
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // PERMISSION-AWARE IMAGE PICKING
  // ============================================================================

  /// Pick Single Image with Permission Check
  static Future<void> _pickImage(
      BuildContext context,
      ImageSource source,
      Function(List<String> imagePaths)? onImagesSelected,
      ) async {
    try {
      bool hasPermission = false;

      if (source == ImageSource.camera) {
        hasPermission = await _permissionService.requestCameraPermission(
          context: context,
          rationaleMessage: 'Camera access is needed to take photos.',
        );
      } else {
        hasPermission = await _permissionService.requestPhotosPermission(
          context: context,
          rationaleMessage: 'Photo library access is needed to select images.',
        );
      }

      if (!hasPermission) {
        if (context.mounted) {
          SnackBarUtil.showWarning(
            context,
            'Permission required to ${source == ImageSource.camera ? 'take photos' : 'access gallery'}',
            title: 'Permission Denied',
          );
        }
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        if (context.mounted) {
          Navigator.of(context).pop();
          onImagesSelected?.call([image.path]);
          SnackBarUtil.showSuccess(
            context,
            'Photo added successfully',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtil.showError(
          context,
          'Failed to pick image: ${e.toString()}',
          title: 'Error',
        );
      }
    }
  }

  // ============================================================================
  // DOCUMENT PICKING - NO PERMISSIONS NEEDED (Uses SAF)
  // ============================================================================

  /// Pick Documents - No storage permission needed on modern Android
  /// file_picker uses Storage Access Framework (SAF) which doesn't require permissions
  static Future<void> _pickDocuments(
      BuildContext context,
      List<String> allowedExtensions,
      Function(List<String> documentPaths)? onDocumentsSelected,
      int? maxFileSize,
      ) async {
    try {
      // Directly pick files - SAF doesn't need storage permissions
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        List<String> filePaths = result.paths.where((path) => path != null).cast<String>().toList();

        // Check file sizes
        if (maxFileSize != null) {
          for (String path in filePaths) {
            final file = File(path);
            final fileSize = await file.length();
            if (fileSize > (maxFileSize * 1024 * 1024)) {
              if (context.mounted) {
                SnackBarUtil.showError(
                  context,
                  'Some files exceed the ${maxFileSize}MB limit',
                  title: 'File Too Large',
                );
              }
              return;
            }
          }
        }

        if (filePaths.isNotEmpty && context.mounted) {
          Navigator.of(context).pop();
          onDocumentsSelected?.call(filePaths);
          SnackBarUtil.showSuccess(
            context,
            '${filePaths.length} ${filePaths.length == 1 ? 'document' : 'documents'} added successfully',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtil.showError(
          context,
          'Failed to pick documents: ${e.toString()}',
          title: 'Error',
        );
      }
    }
  }
}