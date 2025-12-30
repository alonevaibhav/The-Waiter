
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/storage/model/manager/menu_item_model.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../controllers/manager/menu_controller.dart';




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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        constraints: BoxConstraints(
          maxWidth: 700,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
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
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.darkSurfaceVariant
                    : AppTheme.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item == null ? Icons.add : Icons.edit,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item == null ? 'Add Menu Item' : 'Edit Menu Item',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name Field
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Item Name *',
                        prefixIcon: Icon(Icons.restaurant_menu, color: AppTheme.primary),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Category Field
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        labelText: 'Category *',
                        prefixIcon: Icon(Icons.category, color: AppTheme.primary),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Price Field
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price *',
                        prefixIcon: Icon(Icons.currency_rupee, color: AppTheme.primary),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Description Field
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: Icon(Icons.description, color: AppTheme.primary),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Checkboxes
                    Container(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isAvailable,
                        builder: (context, availableValue, _) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: isSpecialOffer,
                            builder: (context, offerValue, _) {
                              return Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppTheme.darkSurfaceVariant
                                      : AppTheme.primaryLight.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => isAvailable.value = !availableValue,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  color: availableValue
                                                      ? AppTheme.success
                                                      : (isDark ? AppTheme.darkSurface : Colors.white),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: availableValue
                                                        ? AppTheme.success
                                                        : AppTheme.darkSurface,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: availableValue
                                                    ? Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: Colors.white,
                                                )
                                                    : null,
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                'Available',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => isSpecialOffer.value = !offerValue,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  color: offerValue
                                                      ? AppTheme.warning
                                                      : (isDark ? AppTheme.darkSurface : Colors.white),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: offerValue
                                                        ? AppTheme.warning
                                                        : AppTheme.info,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: offerValue
                                                    ? Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: Colors.white,
                                                )
                                                    : null,
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                'Special Offer',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Discount Field (conditional)
                    ValueListenableBuilder<bool>(
                      valueListenable: isSpecialOffer,
                      builder: (context, offerValue, _) {
                        return offerValue
                            ? Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: TextField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Discount %',
                              prefixIcon: Icon(Icons.local_offer, color: AppTheme.primary),
                              helperText: 'Enter discount percentage (0-100)',
                            ),
                          ),
                        )
                            : SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Footer with buttons
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurfaceVariant : Colors.grey[50],
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppTheme.surfaceVariant : AppTheme.surface,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      final category = categoryController.text.trim();
                      final priceText = priceController.text.trim();

                      if (name.isEmpty || category.isEmpty || priceText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.white),
                                SizedBox(width: 12),
                                Text('Please fill all required fields'),
                              ],
                            ),
                            backgroundColor: AppTheme.error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        return;
                      }

                      final price = double.tryParse(priceText);
                      if (price == null || price <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.white),
                                SizedBox(width: 12),
                                Text('Please enter a valid price'),
                              ],
                            ),
                            backgroundColor: AppTheme.error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        return;
                      }

                      int? discount;
                      if (isSpecialOffer.value) {
                        if (discountController.text.isNotEmpty) {
                          discount = int.tryParse(discountController.text);
                          if (discount == null || discount < 0 || discount > 100) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.white),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text('Please enter a valid discount (0-100)'),
                                    ),
                                  ],
                                ),
                                backgroundColor: AppTheme.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      item == null ? 'Add Item' : 'Update Item',
                      style: TextStyle(
                        fontSize: 15,
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