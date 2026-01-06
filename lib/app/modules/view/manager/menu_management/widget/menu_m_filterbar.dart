import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../manager.controller/menu_controller.dart';




Widget buildFiltersBar(BuildContext context) {

  final ManagerMenuController controller = Get.find<ManagerMenuController>();


  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
    color: isDark ? AppTheme.darkSurface : AppTheme.surface,
    child: Row(
      children: [
        // Search Field
        Expanded(
          flex: 3,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkSurfaceVariant
                  : AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.search,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: controller.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search menu items by name, category...',
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      isDense: true,
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),

        // Category Dropdown
        Container(
          width: 200,
          height: 56,
          child: Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedCategory.value,
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: theme.textTheme.titleSmall?.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.filter_list,
                color: AppTheme.primary,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: isDark
                  ? AppTheme.darkSurfaceVariant
                  : AppTheme.surfaceVariant,
            ),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ),
            items: controller.categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) controller.setSelectedCategory(value);
            },
          )),
        ),
      ],
    ),
  );
}