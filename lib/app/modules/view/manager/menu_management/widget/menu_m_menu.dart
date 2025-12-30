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
    padding: EdgeInsets.all(40),
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
              crossAxisSpacing: 28,
              mainAxisSpacing: 28,
              childAspectRatio: 0.82,
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
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark
            ? AppTheme.darkSurface
            : AppTheme.surface,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.08),
          blurRadius: 20,
          offset: Offset(0, 8),
          spreadRadius: -4,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
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
        height: 180,
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
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.darkSurface : AppTheme.surface)
                  .withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant,
              size: 48,
              color: AppTheme.primary.withOpacity(0.7),
            ),
          ),
        ),
      ),
      if (item.isSpecialOffer) buildSpecialBadge(context),
      Positioned(
        top: 14,
        right: 14,
        child: buildMenuButton(context, item, controller),
      ),
    ],
  );
}

Widget buildSpecialBadge(BuildContext context) {
  return Positioned(
    top: 14,
    left: 14,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          Icon(Icons.local_offer, color: Colors.white, size: 14),
          SizedBox(width: 6),
          Text(
            'SPECIAL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
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
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.15),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: PopupMenuButton(
      icon: Container(
        padding: EdgeInsets.all(8),
        child: Icon(
          Icons.more_vert,
          size: 20,
          color: isDark ? AppTheme.darkTextPrimary : AppTheme.textSecondary,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
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

  return PopupMenuItem(
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: label == 'Delete' ? color : null,
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
    padding: EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: theme.textTheme.titleLarge?.copyWith(
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        buildCategoryChip(context, item.category),
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
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: isDark
          ? AppTheme.darkSurfaceVariant
          : AppTheme.primaryLight.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      category,
      style: theme.textTheme.labelSmall?.copyWith(
        color: AppTheme.primary,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}

Widget buildCardFooter(BuildContext context, MenuItem item, ManagerMenuController controller) {
  final theme = Theme.of(context);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        '₹${item.price.toStringAsFixed(0)}',
        style: theme.textTheme.headlineMedium?.copyWith(
          color: AppTheme.primary,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
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
          SizedBox(width: 8),
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
      color: color.withOpacity(isActive ? 0.1 : 0.05),
      borderRadius: BorderRadius.circular(8),
    ),
    child: IconButton(
      icon: Icon(
        icon,
        color: isActive ? color : color.withOpacity(0.6),
        size: 20,
      ),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
    ),
  );
}

Widget buildEmptyState(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Center(
    child: Container(
      padding: EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
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
              size: 80,
              color: AppTheme.primary.withOpacity(0.3),
            ),
          ),
          SizedBox(height: 32),
          Text(
            'No menu items found',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Start building your menu by adding your first item',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => showAddEditDialog(context),
            icon: Icon(Icons.add_circle_outline),
            label: Text('Add Your First Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              elevation: 0,
              textStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}