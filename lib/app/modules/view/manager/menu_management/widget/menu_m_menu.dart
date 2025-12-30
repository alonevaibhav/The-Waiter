import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/storage/model/manager/menu_item_model.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../controllers/manager/menu_controller.dart';
import 'menu_m_additem.dart';

Widget buildMenuGrid(BuildContext context) {
  final ManagerMenuController controller = Get.find<ManagerMenuController>();

  return Padding(
    padding: EdgeInsets.all(32), // Reduced from 40
    child: LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = getResponsiveCrossAxisCount(constraints.maxWidth);
        return Obx(() {
          if (controller.filteredItems.isEmpty) {
            return buildEmptyState(context);
          }
          return GridView.builder(
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20, // Reduced from 28
              mainAxisSpacing: 20, // Reduced from 28
              childAspectRatio: 0.88, // Adjusted for better proportions
            ),
            itemCount: controller.filteredItems.length,
            itemBuilder: (context, index) {
              final item = controller.filteredItems[index];
              return buildMenuCard(context, item, controller);
            },
          );
        });
      },
    ),
  );
}

int getResponsiveCrossAxisCount(double width) {
  if (width > 1400) return 4;
  if (width > 1000) return 3;
  if (width > 700) return 2;
  return 1;
}

Widget buildMenuCard(BuildContext context, MenuItem item, ManagerMenuController controller) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Container(
    decoration: BoxDecoration(
      color: isDark ? AppTheme.darkSurface : AppTheme.surface,
      borderRadius: BorderRadius.circular(14), // Reduced from 16
      border: Border.all(
        color: isDark
            ? AppTheme.surfaceVariant.withOpacity(0.2)
            : Colors.grey.withOpacity(0.1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.08),
          blurRadius: 16, // Reduced from 20
          offset: Offset(0, 6), // Reduced from 8
          spreadRadius: -3, // Reduced from -4
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCardImage(context, item, controller),
          Expanded(
            child: buildCardContent(context, item, controller),
          ),
        ],
      ),
    ),
  );
}

Widget buildCardImage(BuildContext context, MenuItem item, ManagerMenuController controller) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Stack(
    children: [
      Container(
        height: 160, // Reduced from 180
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark
                  ? AppTheme.darkSurfaceVariant
                  : AppTheme.primaryLight.withOpacity(0.1),
              isDark
                  ? AppTheme.darkSurfaceVariant.withOpacity(0.7)
                  : AppTheme.primaryLight.withOpacity(0.05),
            ],
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16), // Reduced from 20
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.darkSurface : AppTheme.surface)
                  .withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant,
              size: 42, // Reduced from 48
              color: AppTheme.primary.withOpacity(0.7),
            ),
          ),
        ),
      ),
      if (item.isSpecialOffer) buildSpecialBadge(context),
      Positioned(
        top: 10, // Reduced from 14
        right: 10,
        child: buildMenuButton(context, item, controller),
      ),
    ],
  );
}

Widget buildSpecialBadge(BuildContext context) {
  return Positioned(
    top: 10, // Reduced from 14
    left: 10,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Reduced
      decoration: BoxDecoration(
        color: AppTheme.warning,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppTheme.warning.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, color: Colors.white, size: 12), // Reduced from 14
          SizedBox(width: 5), // Reduced from 6
          Text(
            'SPECIAL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10, // Reduced from 11
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6, // Reduced from 0.8
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildMenuButton(BuildContext context, MenuItem item, ManagerMenuController controller) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Container(
    decoration: BoxDecoration(
      color: isDark ? AppTheme.darkSurface : AppTheme.surface,
      borderRadius: BorderRadius.circular(8), // Reduced from 10
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.15),
          blurRadius: 10, // Reduced from 12
          offset: Offset(0, 3), // Reduced from 4
        ),
      ],
    ),
    child: PopupMenuButton(
      icon: Container(
        padding: EdgeInsets.all(6), // Reduced from 8
        child: Icon(
          Icons.more_vert,
          size: 18, // Reduced from 20
          color: isDark ? AppTheme.darkTextPrimary : AppTheme.textSecondary,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Reduced from 12
      ),
      elevation: 8,
      offset: Offset(0, 8),
      itemBuilder: (context) => [
        buildPopupMenuItem(
          context,
          icon: Icons.edit,
          label: 'Edit',
          color: AppTheme.primary,
          onTap: () => showAddEditDialog(context, item: item),
        ),
        buildPopupMenuItem(
          context,
          icon: Icons.delete,
          label: 'Delete',
          color: AppTheme.error,
          onTap: () => controller.deleteMenuItem(item.id),
        ),
      ],
    ),
  );
}

PopupMenuItem buildPopupMenuItem(
    BuildContext context, {
      required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap,
    }) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10), // Reduced padding
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color), // Reduced from 18
        ),
        SizedBox(width: 10), // Reduced from 12
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: label == 'Delete' ? color : (isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
    onTap: () => Future.delayed(Duration.zero, onTap),
  );
}

Widget buildCardContent(BuildContext context, MenuItem item, ManagerMenuController controller) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Padding(
    padding: EdgeInsets.all(14), // Reduced from 18
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: theme.textTheme.titleLarge?.copyWith(
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16, // Reduced from 18
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        buildCategoryChip(context, item.category),

        // Add description if available
        if (item.description != null && item.description!.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            item.description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
              fontSize: 12,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        Spacer(),
        buildCardFooter(context, item, controller),
      ],
    ),
  );
}

Widget buildCategoryChip(BuildContext context, String category) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced
    decoration: BoxDecoration(
      color: isDark
          ? AppTheme.darkSurfaceVariant
          : AppTheme.primaryLight.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: AppTheme.primary.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: Text(
      category,
      style: theme.textTheme.labelSmall?.copyWith(
        color: AppTheme.primary,
        fontWeight: FontWeight.w600,
        fontSize: 11, // Reduced from 12
      ),
    ),
  );
}

Widget buildCardFooter(BuildContext context, MenuItem item, ManagerMenuController controller) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Container(
    padding: EdgeInsets.only(top: 10), // Added padding
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: isDark
              ? AppTheme.surfaceVariant.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Price with discount if applicable
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.isSpecialOffer && item.discountPercent != null) ...[
              Text(
                '₹${item.price.toStringAsFixed(0)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                  height: 1,
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    '₹${(item.price * (1 - item.discountPercent! / 100)).toStringAsFixed(0)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primary,
                      fontSize: 20, // Reduced from 24
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  SizedBox(width: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${item.discountPercent}% OFF',
                      style: TextStyle(
                        color: AppTheme.success,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              Text(
                '₹${item.price.toStringAsFixed(0)}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primary,
                  fontSize: 20, // Reduced from 24
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        Row(
          children: [
            buildActionButton(
              context,
              icon: item.isAvailable ? Icons.visibility : Icons.visibility_off,
              color: item.isAvailable ? AppTheme.success : AppTheme.textSecondary,
              isActive: item.isAvailable,
              tooltip: item.isAvailable ? 'Available' : 'Unavailable',
              onPressed: () => controller.toggleAvailability(item.id),
            ),
            SizedBox(width: 6), // Reduced from 8
            buildActionButton(
              context,
              icon: Icons.local_offer,
              color: item.isSpecialOffer ? AppTheme.warning : AppTheme.textSecondary,
              isActive: item.isSpecialOffer,
              tooltip: 'Special Offer',
              onPressed: () => controller.toggleSpecialOffer(item.id),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildActionButton(
    BuildContext context, {
      required IconData icon,
      required Color color,
      required bool isActive,
      required String tooltip,
      required VoidCallback onPressed,
    }) {
  return Container(
    decoration: BoxDecoration(
      color: color.withOpacity(isActive ? 0.12 : 0.05),
      borderRadius: BorderRadius.circular(7), // Reduced from 8
      border: isActive ? Border.all(
        color: color.withOpacity(0.3),
        width: 1,
      ) : null,
    ),
    child: IconButton(
      icon: Icon(
        icon,
        color: isActive ? color : color.withOpacity(0.6),
        size: 18, // Reduced from 20
      ),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: const EdgeInsets.all(6), // Reduced from 8
      constraints: const BoxConstraints(),
      splashRadius: 18,
    ),
  );
}

Widget buildEmptyState(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Center(
    child: Container(
      padding: EdgeInsets.all(40), // Reduced from 48
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(28), // Reduced from 32
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkSurfaceVariant
                  : AppTheme.primaryLight.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.1),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: 70, // Reduced from 80
              color: AppTheme.primary.withOpacity(0.3),
            ),
          ),
          SizedBox(height: 28), // Reduced from 32
          Text(
            'No menu items found',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 10), // Reduced from 12
          Text(
            'Start building your menu by adding your first item',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 28), // Reduced from 32
          ElevatedButton.icon(
            onPressed: () => showAddEditDialog(context),
            icon: Icon(Icons.add_circle_outline, size: 20),
            label: Text('Add Your First Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16), // Reduced
              elevation: 0,
              textStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
