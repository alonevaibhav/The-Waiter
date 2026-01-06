import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/storage/model/manager/menu_item_model.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../manager.controller/menu_controller.dart';

void showAddEditDialog(BuildContext context, {MenuItem? item}) {
  final ManagerMenuController controller = Get.find<ManagerMenuController>();

  final nameController = TextEditingController(text: item?.name ?? '');
  final categoryController = TextEditingController(text: item?.category ?? '');
  final priceController = TextEditingController(text: item?.price.toString() ?? '');
  final descController = TextEditingController(text: item?.description ?? '');
  final discountController = TextEditingController(text: item?.discountPercent?.toString() ?? '');
  final isAvailable = ValueNotifier<bool>(item?.isAvailable ?? true);
  final isSpecialOffer = ValueNotifier<bool>(item?.isSpecialOffer ?? false);
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4, // Reduced from 0.45
        constraints: BoxConstraints(
          maxWidth: 650, // Reduced from 700
          maxHeight: MediaQuery.of(context).size.height * 0.8, // Increased for better scrolling
        ),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 0,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Reduced vertical padding
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.darkSurfaceVariant
                    : AppTheme.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10), // Reduced from 12
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item == null ? Icons.add : Icons.edit,
                      color: Colors.white,
                      size: 20, // Reduced from 24
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item == null ? 'Add Menu Item' : 'Edit Menu Item',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 20, // Explicit size
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20), // Reduced from 24
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20), // Consistent padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name Field
                    _buildTextField(
                      controller: nameController,
                      label: 'Item Name *',
                      icon: Icons.restaurant_menu,
                      isDark: isDark,
                    ),
                    SizedBox(height: 14), // Reduced from 16

                    // Category Field
                    _buildTextField(
                      controller: categoryController,
                      label: 'Category *',
                      icon: Icons.category,
                      isDark: isDark,
                    ),
                    SizedBox(height: 14),

                    // Price Field
                    _buildTextField(
                      controller: priceController,
                      label: 'Price *',
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                    ),
                    SizedBox(height: 14),

                    // Description Field
                    _buildTextField(
                      controller: descController,
                      label: 'Description',
                      icon: Icons.description,
                      maxLines: 3,
                      isDark: isDark,
                    ),
                    SizedBox(height: 14),

                    // Checkboxes
                    ValueListenableBuilder<bool>(
                      valueListenable: isAvailable,
                      builder: (context, availableValue, _) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: isSpecialOffer,
                          builder: (context, offerValue, _) {
                            return Container(
                              padding: EdgeInsets.all(14), // Reduced from 16
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.darkSurfaceVariant
                                    : AppTheme.primaryLight.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? AppTheme.surfaceVariant.withOpacity(0.3)
                                      : AppTheme.primaryLight.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildCheckbox(
                                      value: availableValue,
                                      label: 'Available',
                                      color: AppTheme.success,
                                      onTap: () => isAvailable.value = !availableValue,
                                      isDark: isDark,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _buildCheckbox(
                                      value: offerValue,
                                      label: 'Special Offer',
                                      color: AppTheme.warning,
                                      onTap: () => isSpecialOffer.value = !offerValue,
                                      isDark: isDark,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    // Discount Field (conditional)
                    ValueListenableBuilder<bool>(
                      valueListenable: isSpecialOffer,
                      builder: (context, offerValue, _) {
                        return AnimatedSize(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: offerValue
                              ? Padding(
                            padding: EdgeInsets.only(top: 14),
                            child: _buildTextField(
                              controller: discountController,
                              label: 'Discount %',
                              icon: Icons.local_offer,
                              keyboardType: TextInputType.number,
                              helperText: 'Enter discount percentage (0-100)',
                              isDark: isDark,
                            ),
                          )
                              : SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Footer with buttons
            Container(
              padding: EdgeInsets.all(16), // Reduced from 20
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurfaceVariant : Colors.grey[50],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppTheme.surfaceVariant.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24, // Reduced from 28
                        vertical: 12, // Reduced from 16
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14, // Reduced from 15
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Reduced from 12
                  ElevatedButton(
                    onPressed: () => _handleSubmit(
                      context,
                      dialogContext,
                      controller,
                      nameController,
                      categoryController,
                      priceController,
                      descController,
                      discountController,
                      isAvailable,
                      isSpecialOffer,
                      item,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 28, // Reduced from 32
                        vertical: 12, // Reduced from 16
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      item == null ? 'Add Item' : 'Update Item',
                      style: TextStyle(
                        fontSize: 14, // Reduced from 15
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ).then((_) {
    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    descController.dispose();
    discountController.dispose();
    isAvailable.dispose();
    isSpecialOffer.dispose();
  });
}

// Helper widget for text fields
Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required bool isDark,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  String? helperText,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    style: TextStyle(fontSize: 14), // Consistent font size
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 14),
      helperText: helperText,
      helperStyle: TextStyle(fontSize: 12),
      prefixIcon: Padding(
        padding: maxLines > 1
            ? EdgeInsets.only(bottom: (maxLines - 1) * 20.0, left: 12, right: 12)
            : EdgeInsets.all(12),
        child: Icon(
          icon,
          color: AppTheme.primary,
          size: 20, // Consistent icon size
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Reduced padding
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark
              ? AppTheme.surfaceVariant.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark
              ? AppTheme.surfaceVariant.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppTheme.primary,
          width: 2,
        ),
      ),
    ),
  );
}

// Helper widget for checkboxes
Widget _buildCheckbox({
  required bool value,
  required String label,
  required Color color,
  required VoidCallback onTap,
  required bool isDark,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 6), // Reduced from 8
      child: Row(
        children: [
          Container(
            width: 22, // Reduced from 24
            height: 22,
            decoration: BoxDecoration(
              color: value
                  ? color
                  : (isDark ? AppTheme.darkSurface : Colors.white),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? color : Colors.grey.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: value
                ? Icon(
              Icons.check,
              size: 14, // Reduced from 16
              color: Colors.white,
            )
                : null,
          ),
          SizedBox(width: 10), // Reduced from 12
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14, // Reduced from 15
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Extracted validation and submit logic
void _handleSubmit(
    BuildContext context,
    BuildContext dialogContext,
    ManagerMenuController controller,
    TextEditingController nameController,
    TextEditingController categoryController,
    TextEditingController priceController,
    TextEditingController descController,
    TextEditingController discountController,
    ValueNotifier<bool> isAvailable,
    ValueNotifier<bool> isSpecialOffer,
    MenuItem? item,
    ) {
  final name = nameController.text.trim();
  final category = categoryController.text.trim();
  final priceText = priceController.text.trim();

  if (name.isEmpty || category.isEmpty || priceText.isEmpty) {
    _showErrorSnackbar(context, 'Please fill all required fields');
    return;
  }

  final price = double.tryParse(priceText);
  if (price == null || price <= 0) {
    _showErrorSnackbar(context, 'Please enter a valid price');
    return;
  }

  int? discount;
  if (isSpecialOffer.value) {
    if (discountController.text.isNotEmpty) {
      discount = int.tryParse(discountController.text);
      if (discount == null || discount < 0 || discount > 100) {
        _showErrorSnackbar(context, 'Please enter a valid discount (0-100)');
        return;
      }
    }
  }

  final menuItem = MenuItem(
    id: item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    name: name,
    category: category,
    price: price,
    isAvailable: isAvailable.value,
    isSpecialOffer: isSpecialOffer.value,
    description: descController.text.trim().isEmpty
        ? null
        : descController.text.trim(),
    discountPercent: discount,
  );

  if (item == null) {
    controller.addMenuItem(menuItem);
  } else {
    controller.updateMenuItem(menuItem);
  }

  Navigator.of(dialogContext).pop();
}

void _showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Expanded(child: Text(message, style: TextStyle(fontSize: 14))),
        ],
      ),
      backgroundColor: AppTheme.error,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: Duration(seconds: 3),
    ),
  );
}
