import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/Utils/shimmer.dart';
import '../../core/theme/theme_toggle.dart';
import '../../core/widgets/ui_state.dart';
import '../../core/theme/app_theme.dart';

// ==================== DEMO CONTROLLER ====================
class AsyncStateDemoController extends GetxController {
  // State variables
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final dataList = <String>[].obs;
  final dataMap = <String, dynamic>{}.obs;
  final counter = 0.obs;

  // Simulate loading data
  Future<void> loadData() async {
    isLoading.value = true;
    errorMessage.value = "";

    await Future.delayed(const Duration(seconds: 2));

    // Simulate random success/failure
    if (DateTime.now().second % 3 == 0) {
      errorMessage.value = "Failed to load data. Network timeout.";
    } else {
      dataList.value = List.generate(5, (i) => "Item ${i + 1}");
      dataMap.value = {
        'title': 'Demo Data',
        'count': dataList.length,
        'timestamp': DateTime.now().toString(),
      };
    }

    isLoading.value = false;
  }

  // Simulate error
  void triggerError() {
    errorMessage.value = "This is a simulated error message!";
  }

  // Clear data to show empty state
  void clearData() {
    dataList.clear();
    dataMap.clear();
    errorMessage.value = "";
  }

  // Add item to demonstrate reactive updates
  void addItem() {
    counter.value++;
    dataList.add("New Item ${counter.value}");
  }

  // Simulate refresh
  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    dataList.value = List.generate(
        3 + DateTime.now().second % 5,
            (i) => "Refreshed Item ${i + 1}"
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }
}

// ==================== DEMO VIEW ====================
class AsyncStateDemoView extends StatelessWidget {
  AsyncStateDemoView({super.key});

  final controller = Get.put(AsyncStateDemoController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    print('🟢 LOGIN: AsyncStateDemoView building');


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'AsyncStateBuilder Demo',
          style: theme.textTheme.headlineMedium,
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: const [
          ThemeToggleIconButton(),
        ],
      ),
      body: Column(
        children: [
          _buildControlPanel(theme, isDark),
          Expanded(
            child: _buildAsyncStateDemo(theme, isDark),
          ),
        ],
      ),
    );
  }

  // ==================== CONTROL PANEL ====================
  Widget _buildControlPanel(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: isDark ? AppTheme.darkShadowSmall : AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Control Panel',
            style: theme.textTheme.titleLarge,
          ),
          Gap(AppTheme.space12),
          Wrap(
            spacing: AppTheme.space8,
            runSpacing: AppTheme.space8,
            children: [
              _buildControlButton(
                'Load Data',
                PhosphorIcons.downloadSimple(PhosphorIconsStyle.bold),
                AppTheme.info,
                    () => controller.loadData(),
                theme,
              ),
              _buildControlButton(
                'Trigger Error',
                PhosphorIcons.warning(PhosphorIconsStyle.bold),
                AppTheme.error,
                    () => controller.triggerError(),
                theme,
              ),
              _buildControlButton(
                'Clear Data',
                PhosphorIcons.trash(PhosphorIconsStyle.bold),
                AppTheme.warning,
                    () => controller.clearData(),
                theme,
              ),
              _buildControlButton(
                'Add Item',
                PhosphorIcons.plus(PhosphorIconsStyle.bold),
                AppTheme.success,
                    () => controller.addItem(),
                theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      String label,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ThemeData theme,
      ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16.sp),
      label: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.space12,
          vertical: AppTheme.space8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        elevation: 0,
      ),
    );
  }

  // ==================== ASYNC STATE BUILDER DEMO ====================
  Widget _buildAsyncStateDemo(ThemeData theme, bool isDark) {
    return AsyncStateBuilder<AsyncStateDemoController>(
      controller: controller,
      isLoading: controller.isLoading,
      errorMessage: controller.errorMessage,

      // ✅ Custom loading widget with shimmer
      customLoadingWidget: _buildLoadingShimmer(theme, isDark),

      // ✅ Empty state detection
      isEmpty: (ctrl) => ctrl.dataList.isEmpty,
      emptyStateText: 'No items available',

      // ✅ Error state customization
      errorTitle: 'Data Loading Failed',

      // ✅ Retry functionality
      onRetry: () {
        controller.errorMessage.value = '';
        controller.isLoading.value = false;
        controller.loadData();
      },

      // ✅ Pull-to-refresh
      onRefresh: () => controller.refreshData(),

      // ✅ Observe reactive data for real-time updates
      observeData: [
        controller.dataList,
        controller.dataMap,
        controller.counter,
      ],

      // ✅ Builder - Success state
      builder: (ctrl) {
        return ListView(
          padding: EdgeInsets.all(AppTheme.space16),
          children: [
            _buildInfoCard(theme, isDark),
            Gap(AppTheme.space16),
            _buildDataMapCard(theme, isDark),
            Gap(AppTheme.space16),
            _buildDataListCard(theme, isDark),
            Gap(AppTheme.space16),
            _buildFeaturesCard(theme, isDark),
          ],
        );
      },
    );
  }

  // ==================== SHIMMER LOADING STATE ====================
  Widget _buildLoadingShimmer(ThemeData theme, bool isDark) {
    return ListView(
      padding: EdgeInsets.all(AppTheme.space16),
      children: [
        // Info card shimmer
        UniversalShimmer(
          layout: _createInfoCardShimmer(),
          showCard: false,
          cardMarginSU: EdgeInsets.zero,
          baseColor: isDark
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surfaceVariant,
          highlightColor: isDark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        ),
        Gap(AppTheme.space16),

        // Data map card shimmer
        UniversalShimmer(
          layout: _createDataMapShimmer(),
          showCard: true,
          cardMarginSU: EdgeInsets.zero,
          cardPaddingSU: EdgeInsets.all(AppTheme.space16),
          cardElevation: isDark ? 0 : 2,
          baseColor: isDark
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surfaceVariant,
          highlightColor: isDark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        ),
        Gap(AppTheme.space16),

        // Data list card shimmer
        UniversalShimmer(
          layout: _createDataListShimmer(),
          showCard: true,
          cardMarginSU: EdgeInsets.zero,
          cardPaddingSU: EdgeInsets.all(AppTheme.space16),
          cardElevation: isDark ? 0 : 2,
          baseColor: isDark
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surfaceVariant,
          highlightColor: isDark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        ),
        Gap(AppTheme.space16),

        // Features card shimmer
        UniversalShimmer(
          layout: _createFeaturesShimmer(),
          showCard: false,
          cardMarginSU: EdgeInsets.zero,
          baseColor: isDark
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surfaceVariant,
          highlightColor: isDark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        ),
      ],
    );
  }

  // Shimmer layout for info card
  ShimmerLayout _createInfoCardShimmer() {
    final children = <ShimmerChild>[];

    children.addElement(ShimmerElement.circle(
      sizeSU: 24,
      marginSU: EdgeInsets.only(right: 12.w),
    ));

    children.addElement(ShimmerElement.text(
      widthSU: 200,
      heightSU: 16,
      marginSU: EdgeInsets.zero,
    ));

    return ShimmerLayout.row(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.center,
      paddingSU: EdgeInsets.all(AppTheme.space16),
    );
  }

  // Shimmer layout for data map card
  ShimmerLayout _createDataMapShimmer() {
    final children = <ShimmerChild>[];

    // Header row
    final headerRow = <ShimmerChild>[];
    headerRow.addElement(ShimmerElement.circle(
      sizeSU: 20,
      marginSU: EdgeInsets.only(right: 8.w),
    ));
    headerRow.addElement(ShimmerElement.text(
      widthSU: 150,
      heightSU: 18,
      marginSU: EdgeInsets.zero,
    ));

    children.addLayout(ShimmerLayout.row(
      children: headerRow,
      crossAxisAlignment: CrossAxisAlignment.center,
      paddingSU: EdgeInsets.zero,
    ));

    children.addSpacer(heightSU: 12);

    // Data rows
    for (int i = 0; i < 3; i++) {
      final dataRow = <ShimmerChild>[];
      dataRow.addElement(ShimmerElement.text(
        widthSU: 80,
        heightSU: 14,
        marginSU: EdgeInsets.only(right: 8.w),
      ));
      dataRow.addElement(ShimmerElement.text(
        widthSU: 180,
        heightSU: 14,
        marginSU: EdgeInsets.zero,
      ));

      children.addLayout(ShimmerLayout.row(
        children: dataRow,
        crossAxisAlignment: CrossAxisAlignment.center,
        paddingSU: EdgeInsets.zero,
      ));

      if (i < 2) children.addSpacer(heightSU: 8);
    }

    return ShimmerLayout.column(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.start,
      paddingSU: EdgeInsets.zero,
    );
  }

  // Shimmer layout for data list card
  ShimmerLayout _createDataListShimmer() {
    final children = <ShimmerChild>[];

    // Header row
    final headerRow = <ShimmerChild>[];
    headerRow.addElement(ShimmerElement.circle(
      sizeSU: 20,
      marginSU: EdgeInsets.only(right: 8.w),
    ));
    headerRow.addElement(ShimmerElement.text(
      widthSU: 120,
      heightSU: 18,
      marginSU: EdgeInsets.zero,
    ));

    children.addLayout(ShimmerLayout.row(
      children: headerRow,
      crossAxisAlignment: CrossAxisAlignment.center,
      paddingSU: EdgeInsets.zero,
    ));

    children.addSpacer(heightSU: 12);

    // List items
    for (int i = 0; i < 5; i++) {
      final itemRow = <ShimmerChild>[];
      itemRow.addElement(ShimmerElement.circle(
        sizeSU: 18,
        marginSU: EdgeInsets.only(right: 12.w),
      ));
      itemRow.addElement(ShimmerElement.text(
        widthSU: 180,
        heightSU: 14,
        marginSU: EdgeInsets.zero,
      ));

      children.addLayout(ShimmerLayout.row(
        children: itemRow,
        crossAxisAlignment: CrossAxisAlignment.center,
        paddingSU: EdgeInsets.all(12.w),
      ));

      if (i < 4) children.addSpacer(heightSU: 8);
    }

    return ShimmerLayout.column(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.start,
      paddingSU: EdgeInsets.zero,
    );
  }

  // Shimmer layout for features card
  ShimmerLayout _createFeaturesShimmer() {
    final children = <ShimmerChild>[];

    // Title
    children.addElement(ShimmerElement.text(
      widthSU: 220,
      heightSU: 18,
      marginSU: EdgeInsets.only(bottom: 12.h),
    ));

    // Feature items
    for (int i = 0; i < 7; i++) {
      children.addElement(ShimmerElement.text(
        widthSU: i % 2 == 0 ? 280 : 240,
        heightSU: 14,
        marginSU: EdgeInsets.only(bottom: 6.h),
      ));
    }

    return ShimmerLayout.column(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.start,
      paddingSU: EdgeInsets.all(AppTheme.space16),
    );
  }

  // ==================== SUCCESS STATE WIDGETS ====================

  Widget _buildInfoCard(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.info.withOpacity(0.15)
            : AppTheme.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.info.withOpacity(isDark ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.info(PhosphorIconsStyle.fill),
            color: AppTheme.info,
            size: 24.sp,
          ),
          Gap(AppTheme.space12),
          Expanded(
            child: Text(
              'Pull down to refresh the data!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.info,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataMapCard(ThemeData theme, bool isDark) {
    return Obx(() => Container(
      padding: EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: isDark ? AppTheme.darkShadowSmall : AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.database(PhosphorIconsStyle.bold),
                color: theme.colorScheme.primary,
                size: 20.sp,
              ),
              Gap(AppTheme.space8),
              Text(
                'Data Map (Reactive)',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          Gap(AppTheme.space12),
          ...controller.dataMap.entries.map((entry) => Padding(
            padding: EdgeInsets.only(bottom: AppTheme.space8),
            child: Row(
              children: [
                Text(
                  '${entry.key}: ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${entry.value}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    ));
  }

  Widget _buildDataListCard(ThemeData theme, bool isDark) {
    return Obx(() => Container(
      padding: EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: isDark ? AppTheme.darkShadowSmall : AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.listBullets(PhosphorIconsStyle.bold),
                color: AppTheme.success,
                size: 20.sp,
              ),
              Gap(AppTheme.space8),
              Text(
                'Data List (${controller.dataList.length} items)',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          Gap(AppTheme.space12),
          ...controller.dataList.map((item) => Container(
            margin: EdgeInsets.only(bottom: AppTheme.space8),
            padding: EdgeInsets.all(AppTheme.space12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                  color: AppTheme.success,
                  size: 18.sp,
                ),
                Gap(AppTheme.space12),
                Text(
                  item,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          )),
        ],
      ),
    ));
  }

  Widget _buildFeaturesCard(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.accent.withOpacity(0.15)
            : AppTheme.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.accent.withOpacity(isDark ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ AsyncStateBuilder Features',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppTheme.accentLight : AppTheme.accent,
            ),
          ),
          Gap(AppTheme.space12),
          ...[
            '✅ Automatic loading state handling',
            '✅ Error state with retry functionality',
            '✅ Empty state detection',
            '✅ Pull-to-refresh support',
            '✅ Real-time reactive updates',
            '✅ Custom shimmer loading states',
            '✅ Configurable scale & text',
          ].map((feature) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Text(
              feature,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.accent.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          )),
        ],
      ),
    );
  }
}