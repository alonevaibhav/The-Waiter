import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/storage/model/manager/menu_item_model.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../controllers/manager/menu_controller.dart';
import 'menu_m_additem.dart';

class MenuGridView extends StatelessWidget {
  const MenuGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final ManagerMenuController controller = Get.find<ManagerMenuController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = getResponsiveCrossAxisCount(constraints.maxWidth);
          return Obx(() {
            if (controller.filteredItems.isEmpty) {
              return _buildEmptyState(context);
            }
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: controller.filteredItems.length,
              itemBuilder: (context, index) {
                final item = controller.filteredItems[index];
                return _buildMenuCard(context, item, controller);
              },
            );
          });
        },
      ),
    );
  }

  int getResponsiveCrossAxisCount(double width) {
    if (width > 1400) return 5;
    if (width > 1100) return 4;
    if (width > 800) return 3;
    if (width > 500) return 2;
    return 1;
  }

  Widget _buildMenuCard(
      BuildContext context,
      MenuItem item,
      ManagerMenuController controller,
      ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? AppTheme.surfaceVariant.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardImage(context, item, controller),
            Expanded(child: _buildCardContent(context, item, controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(
      BuildContext context,
      MenuItem item,
      ManagerMenuController controller,
      ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          height: 100,
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.darkSurface : AppTheme.surface)
                    .withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant,
                size: 28,
                color: AppTheme.primary.withOpacity(0.7),
              ),
            ),
          ),
        ),
        if (item.isSpecialOffer) _buildSpecialBadge(context),
        const Positioned(
          top: 6,
          right: 6,
          child: _MenuButton(),
        ),
      ],
    );
  }

  Widget _buildSpecialBadge(BuildContext context) {
    return const Positioned(
      top: 6,
      left: 6,
      child: _SpecialBadge(),
    );
  }

  Widget _buildCardContent(
      BuildContext context,
      MenuItem item,
      ManagerMenuController controller,
      ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _buildCategoryChip(context, item.category),
          if (item.description != null && item.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
                fontSize: 11,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          _buildCardFooter(context, item, controller),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String category) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkSurfaceVariant
            : AppTheme.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 1),
      ),
      child: Text(
        category,
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildCardFooter(
      BuildContext context,
      MenuItem item,
      ManagerMenuController controller,
      ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 8),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.isSpecialOffer && item.discountPercent != null) ...[
                  Text(
                    '₹${item.price.toStringAsFixed(0)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                      decoration: TextDecoration.lineThrough,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '₹${(item.price * (1 - item.discountPercent! / 100)).toStringAsFixed(0)}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppTheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '${item.discountPercent}%',
                          style: TextStyle(
                            color: AppTheme.success,
                            fontSize: 8,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              _buildActionButton(
                context:context,
                icon: item.isAvailable
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: item.isAvailable
                    ? AppTheme.success
                    : AppTheme.textSecondary,
                isActive: item.isAvailable,
                tooltip: item.isAvailable ? 'Available' : 'Unavailable',
                onPressed: () => controller.toggleAvailability(item.id),
              ),
              const SizedBox(width: 4),
              _buildActionButton(
                context:context,
                icon: Icons.local_offer,
                color: item.isSpecialOffer
                    ? AppTheme.warning
                    : AppTheme.textSecondary,
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

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required bool isActive,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(isActive ? 0.12 : 0.05),
        borderRadius: BorderRadius.circular(5),
        border:
        isActive ? Border.all(color: color.withOpacity(0.3), width: 1) : null,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isActive ? color : color.withOpacity(0.6),
          size: 14,
        ),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        splashRadius: 14,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.darkSurfaceVariant
                    : AppTheme.primaryLight.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 50,
                color: AppTheme.primary.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No menu items found',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start building your menu by adding your first item',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => showAddEditDialog(context),
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('Add Your First Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                elevation: 0,
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecialBadge extends StatelessWidget {
  const _SpecialBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.warning,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppTheme.warning.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_offer,
            color: Colors.white,
            size: 10,
          ),
          const SizedBox(width: 3),
          Text(
            'SPECIAL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final controller = Get.find<ManagerMenuController>();
    final item = controller.filteredItems.first;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.surface,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton(
        icon: Container(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Icons.more_vert,
            size: 16,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textSecondary,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 6,
        offset: const Offset(0, 6),
        itemBuilder: (context) => [
          _buildPopupMenuItem(
            context,
            icon: Icons.edit,
            label: 'Edit',
            color: AppTheme.primary,
            onTap: () => showAddEditDialog(context, item: item),
          ),
          _buildPopupMenuItem(
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

  PopupMenuItem _buildPopupMenuItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopupMenuItem(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: label == 'Delete'
                  ? color
                  : (isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onTap: () => Future.delayed(Duration.zero, onTap),
    );
  }
}
