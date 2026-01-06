import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../route/app_routes.dart';
import '../../user.controller/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'My Cart',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(() {
            if (cartController.cartItems.isNotEmpty) {
              return TextButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text('Are you sure you want to remove all items?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            cartController.clearCart();
                            Get.back();
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Clear All',
                  style: TextStyle(color: AppTheme.error),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
                SizedBox(height: AppTheme.space16),
                Text(
                  'Your cart is empty',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: AppTheme.space8),
                Text(
                  'Add items to get started',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                SizedBox(height: AppTheme.space24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.space24,
                      vertical: AppTheme.space12,
                    ),
                  ),
                  child: const Text('Browse Menu'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Cart Items List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(AppTheme.space16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartController.cartItems[index];
                  final foodItem = cartItem.foodItem;

                  return Container(
                    margin: EdgeInsets.only(bottom: AppTheme.space12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      boxShadow: isDark
                          ? AppTheme.darkShadowSmall
                          : AppTheme.shadowSmall,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppTheme.space12),
                      child: Row(
                        children: [
                          // Food Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.accent.withOpacity(0.7),
                                  AppTheme.primary,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                foodItem.image,
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                          SizedBox(width: AppTheme.space12),

                          // Food Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: foodItem.isVeg
                                            ? AppTheme.success
                                            : AppTheme.error,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: AppTheme.space8),
                                    Expanded(
                                      child: Text(
                                        foodItem.name,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppTheme.space4),
                                Text(
                                  foodItem.restaurant,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                SizedBox(height: AppTheme.space8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '₹${foodItem.price * cartItem.quantity}',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: theme.colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.radiusSmall,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () => cartController.decreaseQuantity(cartItem),
                                            child: Container(
                                              padding: EdgeInsets.all(AppTheme.space4),
                                              child: Icon(
                                                cartItem.quantity == 1
                                                    ? Icons.delete_outline
                                                    : Icons.remove,
                                                size: 18,
                                                color: theme.colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: AppTheme.space12,
                                            ),
                                            child: Text(
                                              '${cartItem.quantity}',
                                              style: theme.textTheme.labelLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => cartController.increaseQuantity(cartItem),
                                            child: Container(
                                              padding: EdgeInsets.all(AppTheme.space4),
                                              child: Icon(
                                                Icons.add,
                                                size: 18,
                                                color: theme.colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bill Details
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: isDark
                    ? AppTheme.darkShadowMedium
                    : AppTheme.shadowMedium,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppTheme.space16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill Details',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppTheme.space12),
                        _buildBillRow(
                          'Item Total',
                          '₹${cartController.subtotal.toStringAsFixed(2)}',
                          theme,
                        ),
                        _buildBillRow(
                          'Delivery Fee',
                          '₹${cartController.deliveryFee.toStringAsFixed(2)}',
                          theme,
                        ),
                        _buildBillRow(
                          'Platform Fee',
                          '₹${cartController.platformFee.toStringAsFixed(2)}',
                          theme,
                        ),
                        _buildBillRow(
                          'GST (5%)',
                          '₹${cartController.taxes.toStringAsFixed(2)}',
                          theme,
                        ),
                        Divider(height: AppTheme.space16 * 2),
                        _buildBillRow(
                          'To Pay',
                          '₹${cartController.total.toStringAsFixed(2)}',
                          theme,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  // Proceed Button
                  Container(
                    padding: EdgeInsets.all(AppTheme.space16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          NavigationService.pushToCheckoutScreen();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.success,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: AppTheme.space16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusMedium,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Proceed to Checkout',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: AppTheme.space8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBillRow(String label, String value, ThemeData theme, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: theme.colorScheme.onSurface.withOpacity(isBold ? 1.0 : 0.7),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}