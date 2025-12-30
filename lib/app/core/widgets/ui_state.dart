// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:lottie/lottie.dart';
//
// import '../constants/asset_constant.dart';
//
//
// class AsyncStateBuilder<T extends GetxController> extends StatelessWidget {
//   final T controller;
//   final RxBool isLoading;
//   final RxString errorMessage;
//   final Widget Function(T controller) builder;
//
//   // Optional features
//   final VoidCallback? onRetry;
//   final bool Function(T controller)? isEmpty;
//   final Future<void> Function()? onRefresh;
//   final double? scaleFactor;
//
//   // List of reactive variables to observe for real-time updates
//   final List<dynamic>? observeData;
//
//   // Customization
//   final String? loadingText;
//   final String? emptyStateText;
//   final String? errorTitle;
//   final Widget? customLoadingWidget;
//   final Widget? customErrorWidget;
//   final Widget? customEmptyWidget;
//
//   const AsyncStateBuilder({
//     super.key,
//     required this.controller,
//     required this.isLoading,
//     required this.errorMessage,
//     required this.builder,
//     this.onRetry,
//     this.isEmpty,
//     this.onRefresh,
//     this.scaleFactor = 0.8,
//     this.observeData,
//     this.loadingText,
//     this.emptyStateText,
//     this.errorTitle,
//     this.customLoadingWidget,
//     this.customErrorWidget,
//     this.customEmptyWidget,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Force observation of additional data
//       if (observeData != null) {
//         for (var data in observeData!) {
//           if (data is RxMap) {
//             data.length;
//           } else if (data is RxList) {
//             data.length;
//           } else if (data is RxSet) {
//             data.length;
//           } else {
//             data.toString();
//           }
//         }
//       }
//
//       // Loading state
//       if (isLoading.value) {
//         return customLoadingWidget ??
//             _LoadingState(scaleFactor: scaleFactor!, text: loadingText);
//       }
//
//       // Error state
//       final error = errorMessage.value;
//       if (error.isNotEmpty) {
//         return customErrorWidget ??
//             _ErrorState(
//               scaleFactor: scaleFactor!,
//               errorMessage: error,
//               errorTitle: errorTitle,
//               onRetry: onRetry,
//             );
//       }
//
//       // Empty state
//       if (isEmpty != null && isEmpty!(controller)) {
//         return customEmptyWidget ??
//             _EmptyState(
//               scaleFactor: scaleFactor!,
//               text: emptyStateText,
//               onRetry: onRetry,
//             );
//       }
//
//       // Success state
//       final content = builder(controller);
//
//       return onRefresh != null
//           ? RefreshIndicator(
//         onRefresh: onRefresh!,
//         color: Theme.of(context).colorScheme.primary,
//         child: content,
//       )
//           : content;
//     });
//   }
// }
//
// // ==================== LOADING STATE ====================
//
// class _LoadingState extends StatefulWidget {
//   final double scaleFactor;
//   final String? text;
//
//   const _LoadingState({required this.scaleFactor, this.text});
//
//   @override
//   State<_LoadingState> createState() => _LoadingStateState();
// }
//
// class _LoadingStateState extends State<_LoadingState>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//     final primaryColor = theme.colorScheme.primary;
//
//     return Center(
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return FadeTransition(
//             opacity: _fadeAnimation,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       width: 120.w * widget.scaleFactor,
//                       height: 120.h * widget.scaleFactor,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: RadialGradient(
//                           colors: [
//                             primaryColor.withOpacity(0.1),
//                             primaryColor.withOpacity(0.0),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 80.w * widget.scaleFactor,
//                       height: 80.h * widget.scaleFactor,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: primaryColor.withOpacity(0.05),
//                       ),
//                     ),
//                     ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: Container(
//                         width: 56.w * widget.scaleFactor,
//                         height: 56.h * widget.scaleFactor,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: theme.colorScheme.surface,
//                           boxShadow: isDark
//                               ? [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.3),
//                               offset: Offset(0, 4.h),
//                               blurRadius: 10.r,
//                             )
//                           ]
//                               : [
//                             BoxShadow(
//                               color: primaryColor.withOpacity(0.15),
//                               offset: Offset(0, 4.h),
//                               blurRadius: 10.r,
//                             )
//                           ],
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(12.w * widget.scaleFactor),
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               primaryColor,
//                             ),
//                             strokeWidth: 3.5,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Gap(28.h * widget.scaleFactor),
//                 Text(
//                   widget.text ?? 'Loading...',
//                   style: theme.textTheme.titleLarge?.copyWith(
//                     fontSize: 16.sp * widget.scaleFactor,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//                 Gap(8.h * widget.scaleFactor),
//                 Text(
//                   'Please wait a moment',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     fontSize: 13.sp * widget.scaleFactor,
//                     color: theme.textTheme.bodySmall?.color,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ==================== ERROR STATE ====================
// class _ErrorState extends StatefulWidget {
//   final double scaleFactor;
//   final String errorMessage;
//   final String? errorTitle;
//   final VoidCallback? onRetry;
//
//   const _ErrorState({
//     required this.scaleFactor,
//     required this.errorMessage,
//     this.errorTitle,
//     this.onRetry,
//   });
//
//   @override
//   State<_ErrorState> createState() => _ErrorStateState();
// }
//
// class _ErrorStateState extends State<_ErrorState>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
//     );
//
//     _fadeController.forward();
//     _slideController.forward();
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Center(
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 32.w * widget.scaleFactor),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Lottie Animation with Container
//                   Container(
//                     width: 350.w * widget.scaleFactor,
//                     height: 350.h * widget.scaleFactor,
//                     padding: EdgeInsets.all(20.w * widget.scaleFactor),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           theme.colorScheme.error.withOpacity(0.08),
//                           theme.colorScheme.error.withOpacity(0.02),
//                           Colors.transparent,
//                         ],
//                         stops: const [0.0, 0.6, 1.0],
//                       ),
//                     ),
//                     child: Lottie.asset(
//                       AppAssets.errorAnimation,
//                       fit: BoxFit.contain,
//                       repeat: true,
//                     ),
//                   ),
//
//                   Gap(24.h * widget.scaleFactor),
//
//                   // Error Title
//                   Text(
//                     widget.errorTitle ?? 'Oops! Something Went Wrong',
//                     style: theme.textTheme.headlineMedium?.copyWith(
//                       fontSize: 20.sp * widget.scaleFactor,
//                       fontWeight: FontWeight.bold,
//                       color: theme.colorScheme.onSurface,
//                       letterSpacing: -0.3,
//                       height: 1.2,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//
//                   Gap(16.h * widget.scaleFactor),
//
//                   // Error Message Container
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 18.w * widget.scaleFactor,
//                       vertical: 12.h * widget.scaleFactor,
//                     ),
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.errorContainer.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(14.r * widget.scaleFactor),
//                       border: Border.all(
//                         color: theme.colorScheme.error.withOpacity(0.3),
//                         width: 1.5,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
//                           size: 18.sp * widget.scaleFactor,
//                           color: theme.colorScheme.error,
//                         ),
//                         Gap(10.w * widget.scaleFactor),
//                         Flexible(
//                           child: Text(
//                             widget.errorMessage,
//                             textAlign: TextAlign.center,
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               fontSize: 13.sp * widget.scaleFactor,
//                               // color: theme.colorScheme.error,
//                               fontWeight: FontWeight.w600,
//                               height: 1.5,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   Gap(20.h * widget.scaleFactor),
//
//                   // Action Buttons
//                   if (widget.onRetry != null) ...[
//                     Center(
//                       child: Container(
//                         width: 40.r * widget.scaleFactor,
//                         height: 40.r * widget.scaleFactor,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             colors: [
//                               theme.colorScheme.primary,
//                               theme.colorScheme.primary.withOpacity(0.85),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: theme.colorScheme.primary.withOpacity(0.3),
//                               blurRadius: 20,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: Material(
//                           color: Colors.transparent,
//                           shape: const CircleBorder(),
//                           child: InkWell(
//                             onTap: widget.onRetry,
//                             customBorder: const CircleBorder(),
//                             child: Center(
//                               child: Icon(
//                                 PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold),
//                                 size: 22.sp * widget.scaleFactor,
//                                 color: theme.colorScheme.onPrimary,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Gap(20.h * widget.scaleFactor),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ==================== EMPTY STATE ====================
//
// class _EmptyState extends StatefulWidget {
//   final double scaleFactor;
//   final String? text;
//   final VoidCallback? onRetry;
//
//   const _EmptyState({
//     required this.scaleFactor,
//     this.text,
//     this.onRetry,
//   });
//
//   @override
//   State<_EmptyState> createState() => _EmptyStateState();
// }
//
// class _EmptyStateState extends State<_EmptyState>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
//     );
//
//     _fadeController.forward();
//     _slideController.forward();
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Center(
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 32.w * widget.scaleFactor),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Lottie Animation with Container
//                   Container(
//                     width: 300.w * widget.scaleFactor,
//                     height: 300.h * widget.scaleFactor,
//                     padding: EdgeInsets.all(20.w * widget.scaleFactor),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           theme.colorScheme.primary.withOpacity(0.08),
//                           theme.colorScheme.primary.withOpacity(0.02),
//                           Colors.transparent,
//                         ],
//                         stops: const [0.0, 0.6, 1.0],
//                       ),
//                     ),
//                     child: Lottie.asset(
//                       AppAssets.emptyAnimation,
//                       fit: BoxFit.contain,
//                       repeat: true,
//                     ),
//                   ),
//
//                   Gap(24.h * widget.scaleFactor),
//
//                   // Empty Title
//                   Text(
//                     widget.text ?? 'No Data Available',
//                     style: theme.textTheme.headlineMedium?.copyWith(
//                       fontSize: 20.sp * widget.scaleFactor,
//                       fontWeight: FontWeight.bold,
//                       color: theme.colorScheme.onSurface,
//                       letterSpacing: -0.3,
//                       height: 1.2,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//
//                   Gap(16.h * widget.scaleFactor),
//
//                   // Empty Description
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20.w * widget.scaleFactor),
//                     child: Text(
//                       'There\'s nothing here right now.\nCheck back later or add something new!',
//                       textAlign: TextAlign.center,
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         fontSize: 13.sp * widget.scaleFactor,
//                         color: theme.textTheme.bodySmall?.color,
//                         height: 1.6,
//                         letterSpacing: 0.2,
//                       ),
//                     ),
//                   ),
//
//                   Gap(20.h * widget.scaleFactor),
//
//                   // Action Button
//                   if (widget.onRetry != null) ...[
//                     Center(
//                       child: Container(
//                         width: 40.r * widget.scaleFactor,
//                         height: 40.r * widget.scaleFactor,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             colors: [
//                               theme.colorScheme.primary,
//                               theme.colorScheme.primary.withOpacity(0.85),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: theme.colorScheme.primary.withOpacity(0.3),
//                               blurRadius: 20,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: Material(
//                           color: Colors.transparent,
//                           shape: const CircleBorder(),
//                           child: InkWell(
//                             onTap: widget.onRetry,
//                             customBorder: const CircleBorder(),
//                             child: Center(
//                               child: Icon(
//                                 PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold),
//                                 size: 22.sp * widget.scaleFactor,
//                                 color: theme.colorScheme.onPrimary,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Gap(20.h * widget.scaleFactor),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:lottie/lottie.dart';

import '../constants/asset_constant.dart';

class AsyncStateBuilder<T extends GetxController> extends StatelessWidget {
  final T controller;
  final RxBool isLoading;
  final RxString errorMessage;
  final Widget Function(T controller) builder;

  // Optional features
  final VoidCallback? onRetry;
  final bool Function(T controller)? isEmpty;
  final Future<void> Function()? onRefresh;
  final double? scaleFactor;

  // List of reactive variables to observe for real-time updates
  final List<dynamic>? observeData;

  // Customization
  final String? loadingText;
  final String? emptyStateText;
  final String? errorTitle;
  final Widget? customLoadingWidget;
  final Widget? customErrorWidget;
  final Widget? customEmptyWidget;

  const AsyncStateBuilder({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.errorMessage,
    required this.builder,
    this.onRetry,
    this.isEmpty,
    this.onRefresh,
    this.scaleFactor = 1.0,
    this.observeData,
    this.loadingText,
    this.emptyStateText,
    this.errorTitle,
    this.customLoadingWidget,
    this.customErrorWidget,
    this.customEmptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Force observation of additional data
      if (observeData != null) {
        for (var data in observeData!) {
          if (data is RxMap) {
            data.length;
          } else if (data is RxList) {
            data.length;
          } else if (data is RxSet) {
            data.length;
          } else {
            data.toString();
          }
        }
      }

      // Loading state
      if (isLoading.value) {
        return customLoadingWidget ??
            _LoadingState(scaleFactor: scaleFactor!, text: loadingText);
      }

      // Error state
      final error = errorMessage.value;
      if (error.isNotEmpty) {
        return customErrorWidget ??
            _ErrorState(
              scaleFactor: scaleFactor!,
              errorMessage: error,
              errorTitle: errorTitle,
              onRetry: onRetry,
            );
      }

      // Empty state
      if (isEmpty != null && isEmpty!(controller)) {
        return customEmptyWidget ??
            _EmptyState(
              scaleFactor: scaleFactor!,
              text: emptyStateText,
              onRetry: onRetry,
            );
      }

      // Success state
      final content = builder(controller);

      return onRefresh != null
          ? RefreshIndicator(
        onRefresh: onRefresh!,
        color: Theme.of(context).colorScheme.primary,
        child: content,
      )
          : content;
    });
  }
}

// ==================== LOADING STATE (WEB OPTIMIZED) ====================

// class _LoadingState extends StatefulWidget {
//   final double scaleFactor;
//   final String? text;
//
//   const _LoadingState({required this.scaleFactor, this.text});
//
//   @override
//   State<_LoadingState> createState() => _LoadingStateState();
// }
//
// class _LoadingStateState extends State<_LoadingState>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final primaryColor = theme.colorScheme.primary;
//
//     return Center(
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Lottie Animation with subtle gradient background
//             Container(
//               width: 200 * widget.scaleFactor,
//               height: 200 * widget.scaleFactor,
//               padding: EdgeInsets.all(20 * widget.scaleFactor),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: RadialGradient(
//                   colors: [
//                     primaryColor.withOpacity(0.08),
//                     primaryColor.withOpacity(0.02),
//                     Colors.transparent,
//                   ],
//                   stops: const [0.0, 0.6, 1.0],
//                 ),
//               ),
//               child: Lottie.asset(
//                 AppAssets.load,
//                 fit: BoxFit.contain,
//                 repeat: true,
//               ),
//             ),
//             SizedBox(height: 24 * widget.scaleFactor),
//             Text(
//               widget.text ?? 'Loading...',
//               style: theme.textTheme.titleLarge?.copyWith(
//                 fontSize: 18 * widget.scaleFactor,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.3,
//               ),
//             ),
//             SizedBox(height: 8 * widget.scaleFactor),
//             Text(
//               'Please wait a moment',
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 fontSize: 14 * widget.scaleFactor,
//                 color: theme.colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ==================== ERROR STATE (WEB OPTIMIZED) ====================


class _LoadingState extends StatefulWidget {
  final double scaleFactor;
  final String? text;

  const _LoadingState({required this.scaleFactor, this.text});

  @override
  State<_LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<_LoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120.w * widget.scaleFactor,
                      height: 120.h * widget.scaleFactor,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primaryColor.withOpacity(0.1),
                            primaryColor.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 80.w * widget.scaleFactor,
                      height: 80.h * widget.scaleFactor,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(0.05),
                      ),
                    ),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 56.w * widget.scaleFactor,
                        height: 56.h * widget.scaleFactor,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surface,
                          boxShadow: isDark
                              ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(0, 4.h),
                              blurRadius: 10.r,
                            )
                          ]
                              : [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.15),
                              offset: Offset(0, 4.h),
                              blurRadius: 10.r,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.w * widget.scaleFactor),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                            strokeWidth: 3.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(28.h * widget.scaleFactor),
                Text(
                  widget.text ?? 'Loading...',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 16.sp * widget.scaleFactor,
                    letterSpacing: 0.3,
                  ),
                ),
                Gap(8.h * widget.scaleFactor),
                Text(
                  'Please wait a moment',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp * widget.scaleFactor,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatefulWidget {
  final double scaleFactor;
  final String errorMessage;
  final String? errorTitle;
  final VoidCallback? onRetry;

  const _ErrorState({
    required this.scaleFactor,
    required this.errorMessage,
    this.errorTitle,
    this.onRetry,
  });

  @override
  State<_ErrorState> createState() => _ErrorStateState();
}

class _ErrorStateState extends State<_ErrorState>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: EdgeInsets.symmetric(
              horizontal: 40 * widget.scaleFactor,
              vertical: 40 * widget.scaleFactor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie Error Animation
                Container(
                  width: 250 * widget.scaleFactor,
                  height: 250 * widget.scaleFactor,
                  padding: EdgeInsets.all(20 * widget.scaleFactor),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.error.withOpacity(0.08),
                        theme.colorScheme.error.withOpacity(0.02),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                  child: Lottie.asset(
                    AppAssets.errorAnimation,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
                SizedBox(height: 28 * widget.scaleFactor),

                // Error Title
                Text(
                  widget.errorTitle ?? 'Oops! Something Went Wrong',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 22 * widget.scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16 * widget.scaleFactor),

                // Error Message Container
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20 * widget.scaleFactor,
                    vertical: 14 * widget.scaleFactor,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12 * widget.scaleFactor),
                    border: Border.all(
                      color: theme.colorScheme.error.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
                        size: 20 * widget.scaleFactor,
                        color: theme.colorScheme.error,
                      ),
                      SizedBox(width: 12 * widget.scaleFactor),
                      Flexible(
                        child: Text(
                          widget.errorMessage,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14 * widget.scaleFactor,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Retry Button
                if (widget.onRetry != null) ...[
                  SizedBox(height: 28 * widget.scaleFactor),
                  ElevatedButton.icon(
                    onPressed: widget.onRetry,
                    icon: Icon(
                      PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold),
                      size: 18 * widget.scaleFactor,
                    ),
                    label: Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 15 * widget.scaleFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28 * widget.scaleFactor,
                        vertical: 14 * widget.scaleFactor,
                      ),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10 * widget.scaleFactor),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== EMPTY STATE (WEB OPTIMIZED) ====================

class _EmptyState extends StatefulWidget {
  final double scaleFactor;
  final String? text;
  final VoidCallback? onRetry;

  const _EmptyState({
    required this.scaleFactor,
    this.text,
    this.onRetry,
  });

  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: EdgeInsets.symmetric(
              horizontal: 40 * widget.scaleFactor,
              vertical: 40 * widget.scaleFactor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie Empty Animation
                Container(
                  width: 220 * widget.scaleFactor,
                  height: 220 * widget.scaleFactor,
                  padding: EdgeInsets.all(20 * widget.scaleFactor),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.08),
                        theme.colorScheme.primary.withOpacity(0.02),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                  child: Lottie.asset(
                    AppAssets.emptyAnimation,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
                SizedBox(height: 28 * widget.scaleFactor),

                // Empty Title
                Text(
                  widget.text ?? 'No Data Available',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 22 * widget.scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14 * widget.scaleFactor),

                // Empty Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20 * widget.scaleFactor),
                  child: Text(
                    'There\'s nothing here right now.\nCheck back later or add something new!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14 * widget.scaleFactor,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      height: 1.6,
                    ),
                  ),
                ),

                // Refresh Button
                if (widget.onRetry != null) ...[
                  SizedBox(height: 28 * widget.scaleFactor),
                  OutlinedButton.icon(
                    onPressed: widget.onRetry,
                    icon: Icon(
                      PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold),
                      size: 18 * widget.scaleFactor,
                    ),
                    label: Text(
                      'Refresh',
                      style: TextStyle(
                        fontSize: 15 * widget.scaleFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28 * widget.scaleFactor,
                        vertical: 14 * widget.scaleFactor,
                      ),
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10 * widget.scaleFactor),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}