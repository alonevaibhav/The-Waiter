import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../manager.controller/menu_controller.dart';
import 'menu_m_additem.dart';

Widget buildHeader(BuildContext context) {
  final ManagerMenuController controller = Get.find<ManagerMenuController>();

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24), // Reduced from 32
    decoration: BoxDecoration(
      color: isDark ? AppTheme.darkSurface : AppTheme.surface,
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
          blurRadius: 20,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Row(
      children: [
        // Left side: Title and Stats
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Better alignment
            children: [
              // Title
              Text(
                'Menu Management',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textPrimary,
                  fontSize: 36, // Reduced from 42
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(width: 32), // Reduced from 40

              Obx(
                    () => Row(
                  children: [
                    buildStatChip(
                      context,
                      icon: Icons.inventory_2_outlined,
                      label: '${controller.totalItems}',
                      subtitle: 'Total',
                      color: AppTheme.primary,
                    ),
                    SizedBox(width: 16), // Reduced from 24
                    buildStatChip(
                      context,
                      icon: Icons.check_circle_outline,
                      label: '${controller.availableItems}',
                      subtitle: 'Available',
                      color: AppTheme.success,
                    ),
                    SizedBox(width: 16), // Reduced from 24
                    buildStatChip(
                      context,
                      icon: Icons.local_offer_outlined,
                      label: '${controller.specialOffers}',
                      subtitle: 'Special Offers',
                      color: AppTheme.warning,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Right side: Add Button
        ElevatedButton.icon(
          onPressed: () => showAddEditDialog(context),
          icon: Icon(Icons.add_circle_outline, size: 20), // Reduced from 22
          label: Text('Add Menu Item'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16), // Reduced
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15, // Reduced from 16
            ),
          ),
        ),
      ],
    ),
  );
}

//================= Common Widget ===================//

Widget buildStatChip(
    BuildContext context, {
      required IconData icon,
      required String label,
      required String subtitle,
      required Color color,
    }) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced from 20, 12
    decoration: BoxDecoration(
      color: isDark ? AppTheme.darkSurfaceVariant : color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: color.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(6), // Reduced from 8
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18), // Reduced from 20
        ),
        SizedBox(width: 10), // Reduced from 12
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                fontSize: 24, // Reduced from 28
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
            SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
                fontSize: 12, // Reduced from 14
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
