
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/model/manager/menu_item_model.dart';
import '../../../controllers/manager/menu_controller.dart';

class MenuManagementView extends GetView<ManagerMenuController> {
  const MenuManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ManagerMenuController());
    return Container(
      color: Color(0xFFF1F5F9),
      child: Column(
        children: [
          // Header with Actions
          _buildHeader(context),

          // Filters and Search
          _buildFiltersBar(),

          // Menu Items Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.filteredItems.isEmpty) {
                return _buildEmptyState();
              }

              return _buildMenuGrid();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Menu Management',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Obx(() => Text(
                  '${controller.totalItems} total items • ${controller.availableItems} available • ${controller.specialOffers} special offers',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                )),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showAddEditDialog(context),
            icon: Icon(Icons.add),
            label: Text('Add Menu Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar() {
    return Container(
      padding: EdgeInsets.all(24),
      color: Colors.white,
      margin: EdgeInsets.only(top: 1),
      child: Row(
        children: [
          // Search
          Expanded(
            flex: 3,
            child: TextField(
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search menu items...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          SizedBox(width: 16),

          // Category Filter
          Expanded(
            flex: 2,
            child: Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedCategory.value,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              items: controller.categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
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

  Widget _buildMenuGrid() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Obx(() => LayoutBuilder(
        builder: (context, constraints) {
          // Responsive grid: adjust columns based on width
          int crossAxisCount = 4;
          if (constraints.maxWidth < 1400) crossAxisCount = 3;
          if (constraints.maxWidth < 1000) crossAxisCount = 2;
          if (constraints.maxWidth < 700) crossAxisCount = 1;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: controller.filteredItems.length,
            itemBuilder: (context, index) {
              final item = controller.filteredItems[index];
              return _buildMenuCard(context, item);
            },
          );
        },
      )),
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(Icons.restaurant, size: 48, color: Colors.grey[400]),
                ),
              ),

              // Badges
              if (item.isSpecialOffer)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SPECIAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Actions Menu
              Positioned(
                top: 8,
                right: 8,
                child: PopupMenuButton(
                  icon: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Icon(Icons.more_vert, size: 20),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit')
                        ],
                      ),
                      onTap: () => Future.delayed(
                        Duration.zero,
                            () => _showAddEditDialog(context, item: item),
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red))
                        ],
                      ),
                      onTap: () => controller.deleteMenuItem(item.id),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.category,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item.price}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              item.isAvailable ? Icons.visibility : Icons.visibility_off,
                              color: item.isAvailable ? Colors.green : Colors.grey,
                              size: 20,
                            ),
                            onPressed: () => controller.toggleAvailability(item.id),
                            tooltip: item.isAvailable ? 'Available' : 'Unavailable',
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.local_offer,
                              color: item.isSpecialOffer ? Colors.orange : Colors.grey,
                              size: 20,
                            ),
                            onPressed: () => controller.toggleSpecialOffer(item.id),
                            tooltip: 'Special Offer',
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No menu items found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first menu item to get started',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }


  void _showAddEditDialog(BuildContext context, {MenuItem? item}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final categoryController = TextEditingController(
        text: item?.category ?? '');
    final priceController = TextEditingController(
        text: item?.price.toString() ?? ''
    );
    final descController = TextEditingController(text: item?.description ?? '');
    final discountController = TextEditingController(
        text: item?.discountPercent?.toString() ?? ''
    );

    final isAvailable = (item?.isAvailable ?? true).obs;
    final isSpecialOffer = (item?.isSpecialOffer ?? false).obs;

    Get.dialog(
      Dialog(
        child: Container(
          width: 600,
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item == null ? 'Add Menu Item' : 'Edit Menu Item',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Item Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.restaurant_menu),
                  ),
                ),
                SizedBox(height: 16),

                // Category and Price Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: categoryController,
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price (₹) *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.currency_rupee),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Description
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Icon(Icons.description),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Available and Special Offer Checkboxes
                Obx(() =>
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: Text('Available'),
                            value: isAvailable.value,
                            onChanged: (val) => isAvailable.value = val ?? true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: Text('Special Offer'),
                            value: isSpecialOffer.value,
                            onChanged: (val) =>
                            isSpecialOffer.value = val ?? false,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    )),

                // Discount Field (shows only if Special Offer is checked)
                Obx(() =>
                isSpecialOffer.value
                    ? Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Discount %',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_offer),
                      helperText: 'Enter discount percentage (e.g., 10 for 10%)',
                    ),
                  ),
                )
                    : SizedBox.shrink(),
                ),

                SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Cancel'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Validation
                        final name = nameController.text.trim();
                        final category = categoryController.text.trim();
                        final priceText = priceController.text.trim();

                        if (name.isEmpty || category.isEmpty ||
                            priceText.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please fill all required fields',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        final price = double.tryParse(priceText);
                        if (price == null || price <= 0) {
                          Get.snackbar(
                            'Error',
                            'Please enter a valid price',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // Parse discount if Special Offer is checked
                        int? discount;
                        if (isSpecialOffer.value) {
                          if (discountController.text.isNotEmpty) {
                            discount = int.tryParse(discountController.text);
                            if (discount == null || discount < 0 || discount >
                                100) {
                              Get.snackbar(
                                'Error',
                                'Please enter a valid discount percentage (0-100)',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                          }
                        }

                        // Create MenuItem object
                        final menuItem = MenuItem(
                          id: item?.id ?? DateTime
                              .now()
                              .millisecondsSinceEpoch
                              .toString(),
                          name: name,
                          category: category,
                          price: price,
                          isAvailable: isAvailable.value,
                          isSpecialOffer: isSpecialOffer.value,
                          description: descController.text
                              .trim()
                              .isEmpty
                              ? null
                              : descController.text.trim(),
                          discountPercent: discount,
                        );

                        // Save or Update
                        if (item == null) {
                          controller.addMenuItem(menuItem);
                        } else {
                          controller.updateMenuItem(menuItem);
                        }

                        // Close dialog
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(item == null ? 'Add Item' : 'Update Item'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}