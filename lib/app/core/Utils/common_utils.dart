// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import '../../app/core/constants/color_constant.dart';
// import 'custom_drop_down.dart';
//
// class CommonUiUtils {
//   static const double sizeFactor = 0.75; // Size constant variable
//
//   static Widget buildStepHeader(String title, [String? subtitle]) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildText(
//           text: title,
//           style: GoogleFonts.poppins(
//             fontSize: 22.sp * sizeFactor,
//             fontWeight: FontWeight.w700,
//             color: AppColors.primaryLight,
//           ),
//         ),
//         if (subtitle != null && subtitle.trim().isNotEmpty) ...[
//           Gap(6.h * sizeFactor),
//           buildText(
//             text: subtitle,
//             style: GoogleFonts.poppins(
//               fontSize: 14.sp * sizeFactor,
//               color: AppColors.textSecondary,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ],
//     );
//   }
//
//   /// Calendar Date Picker Field
//   static Widget buildDatePickerField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     String? Function(String?)? validator,
//     String? errorText,
//     DateTime? initialDate,
//     DateTime? firstDate,
//     DateTime? lastDate,
//     String dateFormat = 'dd/MM/yyyy',
//     ValueChanged<DateTime>? onDateSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildText(
//           text: label,
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp * sizeFactor,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         Gap(8.h * sizeFactor),
//         TextFormField(
//           controller: controller,
//           readOnly: true,
//           style: GoogleFonts.poppins(fontSize: 20.sp * sizeFactor),
//           validator: validator,
//           onTap: () async {
//             final selectedDate = await _showCustomDatePicker(
//               context: controller.text.isNotEmpty
//                   ? null
//                   : null, // This needs proper context
//               initialDate: initialDate ?? DateTime.now(),
//               firstDate: firstDate ?? DateTime(1900),
//               lastDate: lastDate ?? DateTime(2100),
//             );
//
//             if (selectedDate != null) {
//               controller.text = DateFormat(dateFormat).format(selectedDate);
//               if (onDateSelected != null) {
//                 onDateSelected(selectedDate);
//               }
//             }
//           },
//           decoration: InputDecoration(
//             hintText: hint,
//             prefixIcon: Icon(
//               icon,
//               color: AppColors.primaryLight,
//               size: 20.w * sizeFactor,
//             ),
//             suffixIcon: Icon(
//               PhosphorIcons.caretDown(PhosphorIconsStyle.regular),
//               color: AppColors.textSecondary,
//               size: 16.w * sizeFactor,
//             ),
//             filled: true,
//             fillColor: AppColors.background,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(
//                 color: AppColors.lightColor.withOpacity(0.3),
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(
//                 color: AppColors.lightColor.withOpacity(0.3),
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(color: AppColors.error, width: 1),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(color: AppColors.error, width: 2),
//             ),
//             contentPadding: EdgeInsets.symmetric(
//               horizontal: 16.w * sizeFactor,
//               vertical: 16.h * sizeFactor,
//             ),
//             errorText: errorText,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Custom Date Picker with attractive design
//   static Future<DateTime?> _showCustomDatePicker({
//     required BuildContext?
//     context, // Made nullable since we can't always pass context
//     required DateTime initialDate,
//     required DateTime firstDate,
//     required DateTime lastDate,
//   }) async {
//     if (context == null) return null; // Return null if no context provided
//
//     return showDialog<DateTime>(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: 350.w * sizeFactor,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20.r * sizeFactor),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primaryLight.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Header
//                 Container(
//                   padding: EdgeInsets.all(20.w * sizeFactor),
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryLight.withOpacity(0.1),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20.r * sizeFactor),
//                       topRight: Radius.circular(20.r * sizeFactor),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         PhosphorIcons.calendar(PhosphorIconsStyle.fill),
//                         color: AppColors.primaryLight,
//                         size: 24.w * sizeFactor,
//                       ),
//                       Gap(12.w * sizeFactor),
//                       Text(
//                         'Select Date',
//                         style: GoogleFonts.poppins(
//                           fontSize: 18.sp * sizeFactor,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.primaryLight,
//                         ),
//                       ),
//                       const Spacer(),
//                       InkWell(
//                         onTap: () => Navigator.of(context).pop(),
//                         borderRadius: BorderRadius.circular(20.r * sizeFactor),
//                         child: Container(
//                           padding: EdgeInsets.all(8.w * sizeFactor),
//                           child: Icon(
//                             Icons.close,
//                             color: AppColors.textSecondary,
//                             size: 20.w * sizeFactor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Calendar
//                 Padding(
//                   padding: EdgeInsets.all(20.w * sizeFactor),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                       colorScheme: ColorScheme.light(
//                         primary: AppColors.primaryLight,
//                         onPrimary: Colors.white,
//                         surface: Colors.white,
//                         onSurface: AppColors.textPrimary,
//                       ),
//                       textTheme: TextTheme(
//                         headlineSmall: GoogleFonts.poppins(
//                           fontSize: 20.sp * sizeFactor,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textPrimary,
//                         ),
//                         bodyLarge: GoogleFonts.poppins(
//                           fontSize: 14.sp * sizeFactor,
//                           color: AppColors.textPrimary,
//                         ),
//                         bodyMedium: GoogleFonts.poppins(
//                           fontSize: 12.sp * sizeFactor,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ),
//                     child: CalendarDatePicker(
//                       initialDate: initialDate,
//                       firstDate: firstDate,
//                       lastDate: lastDate,
//                       onDateChanged: (DateTime date) {
//                         Navigator.of(context).pop(date);
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   static Widget buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     int? maxLength,
//
//     String? Function(String?)? validator,
//     String? errorText,
//     ValueChanged<String>? onChanged,
//     GestureTapCallback? onTap,
//
//     bool readOnly = false,
//     bool obscureText = false, // <-- ADDED to fix your password field
//     Widget? suffixIcon,       // <-- ADDED for eye icon
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildText(
//           text: label,
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp * sizeFactor,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         SizedBox(height: 8.h * sizeFactor),
//
//         /// -- INPUT FIELD --
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLines: obscureText ? 1 : maxLines,
//           maxLength: maxLength,
//           style: GoogleFonts.poppins(fontSize: 16.sp * sizeFactor),
//           validator: validator,
//           onChanged: onChanged,
//           onTap: onTap,
//           readOnly: readOnly,
//           obscureText: obscureText, // <-- FIXED
//
//           decoration: InputDecoration(
//             hintText: hint,
//             prefixIcon: Icon(
//               icon,
//               color: AppColors.primaryLight,
//               size: 20.w * sizeFactor,
//             ),
//
//             suffixIcon: suffixIcon, // <-- ADDED
//
//             filled: true,
//             fillColor: AppColors.background,
//
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(
//                 color: AppColors.lightColor.withOpacity(0.3),
//               ),
//             ),
//
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(
//                 color: AppColors.lightColor.withOpacity(0.3),
//               ),
//             ),
//
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(
//                 color: AppColors.primaryLight,
//                 width: 2,
//               ),
//             ),
//
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(color: AppColors.error, width: 1),
//             ),
//
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r * sizeFactor),
//               borderSide: BorderSide(color: AppColors.error, width: 2),
//             ),
//
//             contentPadding: EdgeInsets.symmetric(
//               horizontal: 16.w * sizeFactor,
//               vertical: 16.h * sizeFactor,
//             ),
//
//             errorText: errorText,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Custom Dropdown Field using CustomDropdownField
//   static Widget buildCustomDropdownField<T>({
//     required String label,
//     required T? value,
//     required List<T> items,
//     required String Function(T) itemLabelBuilder,
//     required ValueChanged<T?> onChanged,
//     required IconData icon,
//     String? hintText,
//     FormFieldValidator<T>? validator,
//     bool isRequired = false,
//   }) {
//     return CustomDropdownField<T>(
//       value: value,
//       labelText: label,
//       hintText: hintText,
//       items: items,
//       itemLabelBuilder: itemLabelBuilder,
//       onChanged: onChanged,
//       prefixIcon: icon,
//       validator: validator,
//       isRequired: isRequired,
//       borderColor: AppColors.lightColor.withOpacity(0.3),
//       focusedBorderColor: AppColors.primaryLight,
//       fillColor: AppColors.background,
//       borderRadius: 12.r * sizeFactor,
//       labelStyle: GoogleFonts.poppins(
//         fontSize: 16.sp * sizeFactor,
//         fontWeight: FontWeight.w600,
//         color: AppColors.textPrimary,
//       ),
//       itemTextStyle: GoogleFonts.poppins(fontSize: 16.sp * sizeFactor),
//     );
//   }
//
//   static Future<T?> showCustomDialog<T>({
//     required BuildContext context,
//     required String title,
//     required String message,
//     String? primaryButtonText,
//     String? secondaryButtonText,
//     VoidCallback? onPrimaryPressed,
//     VoidCallback? onSecondaryPressed,
//     IconData? icon,
//     Color? iconColor,
//     Color? primaryButtonColor,
//     Color? backgroundColor,
//     bool barrierDismissible = true,
//     Widget? customContent,
//     double? maxWidth,
//   }) async {
//     return showDialog<T>(
//       context: context,
//       barrierDismissible: barrierDismissible,
//       barrierColor: Colors.black.withOpacity(0.5),
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: maxWidth ?? 400.w * sizeFactor,
//             ),
//             child: Card(
//               elevation: 20,
//               shadowColor: AppColors.primaryLight.withOpacity(0.3),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.r * sizeFactor),
//               ),
//               color: backgroundColor ?? Colors.white,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.r * sizeFactor),
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       (backgroundColor ?? Colors.white),
//                       (backgroundColor ?? Colors.white).withOpacity(0.9),
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Header with icon and close button
//                     Container(
//                       padding: EdgeInsets.all(20.w * sizeFactor),
//                       decoration: BoxDecoration(
//                         color: (iconColor ?? AppColors.primaryLight)
//                             .withOpacity(0.1),
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20.r * sizeFactor),
//                           topRight: Radius.circular(20.r * sizeFactor),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           if (icon != null) ...[
//                             Container(
//                               padding: EdgeInsets.all(12.w * sizeFactor),
//                               decoration: BoxDecoration(
//                                 color: (iconColor ?? AppColors.primaryLight)
//                                     .withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(
//                                   50.r * sizeFactor,
//                                 ),
//                               ),
//                               child: Icon(
//                                 icon,
//                                 color: iconColor ?? AppColors.primaryLight,
//                                 size: 28.w * sizeFactor,
//                               ),
//                             ),
//                             Gap(16.w * sizeFactor),
//                           ],
//                           Expanded(
//                             child: buildText(
//                               text: title,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 20.sp * sizeFactor,
//                                 fontWeight: FontWeight.w700,
//                                 color: AppColors.textPrimary,
//                               ),
//                             ),
//                           ),
//                           if (barrierDismissible)
//                             InkWell(
//                               onTap: () => Navigator.of(context).pop(),
//                               borderRadius: BorderRadius.circular(
//                                 20.r * sizeFactor,
//                               ),
//                               child: Container(
//                                 padding: EdgeInsets.all(8.w * sizeFactor),
//                                 child: Icon(
//                                   Icons.close,
//                                   color: AppColors.textSecondary,
//                                   size: 20.w * sizeFactor,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//
//                     // Content
//                     Padding(
//                       padding: EdgeInsets.all(20.w * sizeFactor),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (customContent != null)
//                             customContent
//                           else
//                             buildText(
//                               text: message,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16.sp * sizeFactor,
//                                 color: AppColors.textSecondary,
//                                 height: 1.5,
//                               ),
//                             ),
//
//                           Gap(24.h * sizeFactor),
//
//                           // Action buttons
//                           Row(
//                             children: [
//                               if (secondaryButtonText != null) ...[
//                                 Expanded(
//                                   child: _buildDialogButton(
//                                     text: secondaryButtonText,
//                                     onPressed:
//                                         onSecondaryPressed ??
//                                         () => Navigator.of(context).pop(),
//                                     backgroundColor: Colors.grey.shade100,
//                                     textColor: AppColors.textSecondary,
//                                     borderColor: Colors.grey.shade300,
//                                   ),
//                                 ),
//                                 Gap(12.w * sizeFactor),
//                               ],
//                               Expanded(
//                                 child: _buildDialogButton(
//                                   text: primaryButtonText ?? 'OK',
//                                   onPressed:
//                                       onPrimaryPressed ??
//                                       () => Navigator.of(context).pop(),
//                                   backgroundColor:
//                                       primaryButtonColor ??
//                                       AppColors.primaryLight,
//                                   textColor: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   /// Helper method to build dialog buttons
//   static Widget _buildDialogButton({
//     required String text,
//     required VoidCallback onPressed,
//     Color? backgroundColor,
//     Color? textColor,
//     Color? borderColor,
//   }) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor ?? AppColors.primaryLight,
//         elevation: 0,
//         padding: EdgeInsets.symmetric(vertical: 14.h * sizeFactor),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r * sizeFactor),
//           side: borderColor != null
//               ? BorderSide(color: borderColor, width: 1)
//               : BorderSide.none,
//         ),
//       ),
//       child: buildText(
//         text: text,
//         style: GoogleFonts.poppins(
//           fontSize: 16.sp * sizeFactor,
//           fontWeight: FontWeight.w600,
//           color: textColor ?? Colors.white,
//         ),
//       ),
//     );
//   }
//
//   static Widget buildText({
//     required String text,
//     required TextStyle style,
//     TextAlign? textAlign,
//     int? maxLines,
//     TextOverflow? overflow,
//   }) {
//     return Text(
//       text,
//       style: style,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       overflow: overflow,
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/app_theme.dart';
import 'custom_drop_down.dart';

class CommonUiUtils {
  static const double sizeFactor = 0.75; // Size constant variable

  static Widget buildStepHeader(BuildContext context, String title, [String? subtitle]) {

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? AppTheme.primaryLight : AppTheme.primary;
    final secondaryColor = isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildText(
          text: title,
          style: GoogleFonts.poppins(
            fontSize: 22.sp * sizeFactor,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        if (subtitle != null && subtitle.trim().isNotEmpty) ...[
          Gap(6.h * sizeFactor),
          buildText(
            text: subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14.sp * sizeFactor,
              color: secondaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  /// Calendar Date Picker Field
  static Widget buildDatePickerField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    String? errorText,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String dateFormat = 'dd/MM/yyyy',
    ValueChanged<DateTime>? onDateSelected,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final hintColor = isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textTertiary;
    final textColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final fillColor = isDarkMode ? AppTheme.darkSurfaceVariant : AppTheme.surfaceVariant;
    final primaryColor = isDarkMode ? AppTheme.primaryLight : AppTheme.primary;
    final secondaryColor = isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildText(
          text: label,
          style: GoogleFonts.poppins(
            fontSize: 16.sp * sizeFactor,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        Gap(8.h * sizeFactor),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: GoogleFonts.inter(
            fontSize: 16.sp * sizeFactor,
            color: textColor,
          ),
          validator: validator,
          onTap: () async {
            final selectedDate = await _showCustomDatePicker(
              context: context,
              initialDate: initialDate ?? DateTime.now(),
              firstDate: firstDate ?? DateTime(1900),
              lastDate: lastDate ?? DateTime(2100),
            );

            if (selectedDate != null) {
              controller.text = DateFormat(dateFormat).format(selectedDate);
              if (onDateSelected != null) {
                onDateSelected(selectedDate);
              }
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp * sizeFactor,
              color: hintColor,
            ),
            prefixIcon: Icon(
              icon,
              color: primaryColor,
              size: 20.w * sizeFactor,
            ),
            suffixIcon: Icon(
              PhosphorIcons.caretDown(PhosphorIconsStyle.regular),
              color: secondaryColor,
              size: 16.w * sizeFactor,
            ),
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(color: primaryColor, width: 2.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(color: AppTheme.error, width: 1.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(color: AppTheme.error, width: 2.w),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w * sizeFactor,
              vertical: 16.h * sizeFactor,
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }

  /// Custom Date Picker with attractive design
  static Future<DateTime?> _showCustomDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDarkMode ? AppTheme.darkSurface : AppTheme.surface;
    final primaryColor = isDarkMode ? AppTheme.primaryLight : AppTheme.primary;
    final textPrimaryColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondaryColor = isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final shadows = isDarkMode ? AppTheme.darkShadowLarge : AppTheme.shadowLarge;

    return showDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 350.w * sizeFactor,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: shadows,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20.w * sizeFactor),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.radiusLarge),
                      topRight: Radius.circular(AppTheme.radiusLarge),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIcons.calendar(PhosphorIconsStyle.fill),
                        color: primaryColor,
                        size: 24.w * sizeFactor,
                      ),
                      Gap(12.w * sizeFactor),
                      Text(
                        'Select Date',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp * sizeFactor,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        child: Container(
                          padding: EdgeInsets.all(8.w * sizeFactor),
                          child: Icon(
                            Icons.close,
                            color: textSecondaryColor,
                            size: 20.w * sizeFactor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Calendar
                Padding(
                  padding: EdgeInsets.all(20.w * sizeFactor),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: isDarkMode
                          ? ColorScheme.dark(
                        primary: primaryColor,
                        onPrimary: Colors.black,
                        surface: surfaceColor,
                        onSurface: textPrimaryColor,
                      )
                          : ColorScheme.light(
                        primary: primaryColor,
                        onPrimary: AppTheme.textOnPrimary,
                        surface: surfaceColor,
                        onSurface: textPrimaryColor,
                      ),
                      textTheme: TextTheme(
                        headlineSmall: GoogleFonts.poppins(
                          fontSize: 20.sp * sizeFactor,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                        bodyLarge: GoogleFonts.inter(
                          fontSize: 14.sp * sizeFactor,
                          color: textPrimaryColor,
                        ),
                        bodyMedium: GoogleFonts.inter(
                          fontSize: 12.sp * sizeFactor,
                          color: textSecondaryColor,
                        ),
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: initialDate,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      onDateChanged: (DateTime date) {
                        Navigator.of(context).pop(date);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
    String? errorText,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    bool readOnly = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final hintColor = isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textTertiary;
    final textColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final fillColor = isDarkMode ? AppTheme.darkSurfaceVariant : AppTheme.surfaceVariant;
    final primaryColor = isDarkMode ? AppTheme.primaryLight : AppTheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildText(
          text: label,
          style: GoogleFonts.poppins(
            fontSize: 16.sp * sizeFactor,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        Gap(8.h * sizeFactor),

        /// -- INPUT FIELD --
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          maxLength: maxLength,
          style: GoogleFonts.inter(
            fontSize: 16.sp * sizeFactor,
            color: textColor,
          ),
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp * sizeFactor,
              color: hintColor,
            ),
            prefixIcon: Icon(
              icon,
              color: primaryColor,
              size: 20.w * sizeFactor,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(
                color: primaryColor,
                width: 2.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(color: AppTheme.error, width: 1.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(color: AppTheme.error, width: 2.w),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w * sizeFactor,
              vertical: 16.h * sizeFactor,
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }

  /// Custom Dropdown Field using CustomDropdownField
  static Widget buildCustomDropdownField<T>({
    required BuildContext context,
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabelBuilder,
    required ValueChanged<T?> onChanged,
    required IconData icon,
    String? hintText,
    FormFieldValidator<T>? validator,
    bool isRequired = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final fillColor = isDarkMode ? AppTheme.darkSurfaceVariant : AppTheme.surfaceVariant;
    final primaryColor = isDarkMode ? AppTheme.primaryLight : AppTheme.primary;

    return CustomDropdownField<T>(
      value: value,
      labelText: label,
      hintText: hintText,
      items: items,
      itemLabelBuilder: itemLabelBuilder,
      onChanged: onChanged,
      prefixIcon: icon,
      validator: validator,
      isRequired: isRequired,
      borderColor: Colors.transparent,
      focusedBorderColor: primaryColor,
      fillColor: fillColor,
      borderRadius: AppTheme.radiusMedium,
      labelStyle: GoogleFonts.poppins(
        fontSize: 16.sp * sizeFactor,
        fontWeight: FontWeight.w600,
        color: labelColor,
      ),
      itemTextStyle: GoogleFonts.inter(
        fontSize: 16.sp * sizeFactor,
        color: textColor,
      ),
    );
  }

  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    IconData? icon,
    Color? iconColor,
    Color? primaryButtonColor,
    Color? backgroundColor,
    bool barrierDismissible = true,
    Widget? customContent,
    double? maxWidth,
  }) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = backgroundColor ?? (isDarkMode ? AppTheme.darkSurface : AppTheme.surface);
    final textPrimaryColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondaryColor = isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final shadows = isDarkMode ? AppTheme.darkShadowLarge : AppTheme.shadowLarge;
    final defaultIconColor = iconColor ?? (isDarkMode ? AppTheme.primaryLight : AppTheme.primary);
    final defaultPrimaryButtonColor = primaryButtonColor ?? (isDarkMode ? AppTheme.primaryLight : AppTheme.primary);
    final buttonTextColor = isDarkMode ? Colors.black : AppTheme.textOnPrimary;
    final secondaryBgColor = isDarkMode ? AppTheme.darkSurfaceVariant : AppTheme.surfaceVariant;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? 400.w * sizeFactor,
            ),
            child: Card(
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              color: surfaceColor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  color: surfaceColor,
                  boxShadow: shadows,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with icon and close button
                    Container(
                      padding: EdgeInsets.all(20.w * sizeFactor),
                      decoration: BoxDecoration(
                        color: defaultIconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.radiusLarge),
                          topRight: Radius.circular(AppTheme.radiusLarge),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (icon != null) ...[
                            Container(
                              padding: EdgeInsets.all(12.w * sizeFactor),
                              decoration: BoxDecoration(
                                color: defaultIconColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusCircular,
                                ),
                              ),
                              child: Icon(
                                icon,
                                color: defaultIconColor,
                                size: 28.w * sizeFactor,
                              ),
                            ),
                            Gap(16.w * sizeFactor),
                          ],
                          Expanded(
                            child: buildText(
                              text: title,
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp * sizeFactor,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                            ),
                          ),
                          if (barrierDismissible)
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusSmall,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(8.w * sizeFactor),
                                child: Icon(
                                  Icons.close,
                                  color: textSecondaryColor,
                                  size: 20.w * sizeFactor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Content
                    Padding(
                      padding: EdgeInsets.all(20.w * sizeFactor),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (customContent != null)
                            customContent
                          else
                            buildText(
                              text: message,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp * sizeFactor,
                                color: textSecondaryColor,
                                height: 1.5,
                              ),
                            ),

                          Gap(24.h * sizeFactor),

                          // Action buttons
                          Row(
                            children: [
                              if (secondaryButtonText != null) ...[
                                Expanded(
                                  child: _buildDialogButton(
                                    text: secondaryButtonText,
                                    onPressed: onSecondaryPressed ??
                                            () => Navigator.of(context).pop(),
                                    backgroundColor: secondaryBgColor,
                                    textColor: textPrimaryColor,
                                    borderColor: Colors.transparent,
                                  ),
                                ),
                                Gap(12.w * sizeFactor),
                              ],
                              Expanded(
                                child: _buildDialogButton(
                                  text: primaryButtonText ?? 'OK',
                                  onPressed: onPrimaryPressed ??
                                          () => Navigator.of(context).pop(),
                                  backgroundColor: defaultPrimaryButtonColor,
                                  textColor: buttonTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Helper method to build dialog buttons
  static Widget _buildDialogButton({
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppTheme.primary,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 14.h * sizeFactor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          side: borderColor != null
              ? BorderSide(color: borderColor, width: 1.w)
              : BorderSide.none,
        ),
      ),
      child: buildText(
        text: text,
        style: GoogleFonts.inter(
          fontSize: 16.sp * sizeFactor,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppTheme.textOnPrimary,
        ),
      ),
    );
  }

  static Widget buildText({
    required String text,
    required TextStyle style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}