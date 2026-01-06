import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_waiter/app/modules/view/user/user.controller/user_controller.dart';
import '../../../../core/theme/app_theme.dart';
import 'food_item_card/food_item_card.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserDashboardController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Row(
          children: [
            Icon(
              Icons.location_on,
              color: AppTheme.error,
              size: 20,
            ),
            SizedBox(width: AppTheme.space4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Home',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Pune, Maharashtra',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: theme.colorScheme.surface,
            padding: EdgeInsets.all(AppTheme.space16),
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: 'Search for dishes, restaurants...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.textTertiary,
                ),
                filled: true,
                fillColor: isDark
                    ? AppTheme.darkSurfaceVariant
                    : AppTheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Category Tabs
          Container(
            height: 50,
            color: theme.colorScheme.surface,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppTheme.space16),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final isSelected = controller.selectedCategory.value == index;
                return GestureDetector(
                  onTap: () => controller.selectCategory(index),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: AppTheme.space12,
                      top: AppTheme.space8,
                      bottom: AppTheme.space8,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.space20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : (isDark
                          ? AppTheme.darkSurfaceVariant
                          : AppTheme.surfaceVariant),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      boxShadow: isSelected
                          ? (isDark
                          ? AppTheme.darkShadowSmall
                          : AppTheme.shadowSmall)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        controller.categories[index],
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Food Items List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppTheme.space16),
              itemCount: controller.foodItems.length,
              itemBuilder: (context, index) {
                final item = controller.foodItems[index];
                return FoodItemCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}