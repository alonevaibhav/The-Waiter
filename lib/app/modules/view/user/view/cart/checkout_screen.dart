import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../route/app_routes.dart';
import '../../user.controller/cart_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedAddress = 'Home';
  String selectedPayment = 'Cash on Delivery';
  final TextEditingController instructionsController = TextEditingController();

  final List<Map<String, dynamic>> addresses = [
    {
      'label': 'Home',
      'address': 'Flat 201, Building A, Pune, Maharashtra - 411001',
      'icon': Icons.home,
    },
    {
      'label': 'Work',
      'address': 'Office 5B, Tech Park, Hinjewadi, Pune - 411057',
      'icon': Icons.work,
    },
    {
      'label': 'Other',
      'address': 'Shop 12, Main Street, Koregaon Park, Pune - 411001',
      'icon': Icons.location_on,
    },
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Cash on Delivery',
      'icon': Icons.money,
      'subtitle': 'Pay when you receive',
    },
    {
      'name': 'UPI',
      'icon': Icons.payment,
      'subtitle': 'Google Pay, PhonePe, Paytm',
    },
    {
      'name': 'Card',
      'icon': Icons.credit_card,
      'subtitle': 'Credit or Debit card',
    },
  ];

  @override
  void dispose() {
    instructionsController.dispose();
    super.dispose();
  }

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
          'Checkout',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address Section
                  Container(
                    color: theme.colorScheme.surface,
                    padding: EdgeInsets.all(AppTheme.space16),
                    margin: EdgeInsets.only(bottom: AppTheme.space8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppTheme.error,
                              size: 20,
                            ),
                            SizedBox(width: AppTheme.space8),
                            Text(
                              'Delivery Address',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.space16),
                        ...addresses.map((addr) {
                          final isSelected = selectedAddress == addr['label'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAddress = addr['label'];
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: AppTheme.space12),
                              padding: EdgeInsets.all(AppTheme.space12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusMedium,
                                ),
                                color: isSelected
                                    ? theme.colorScheme.primary.withOpacity(0.05)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    addr['icon'],
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  SizedBox(width: AppTheme.space12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addr['label'],
                                          style: theme.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? theme.colorScheme.primary
                                                : null,
                                          ),
                                        ),
                                        SizedBox(height: AppTheme.space4),
                                        Text(
                                          addr['address'],
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: theme.colorScheme.primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  // Payment Method Section
                  Container(
                    color: theme.colorScheme.surface,
                    padding: EdgeInsets.all(AppTheme.space16),
                    margin: EdgeInsets.only(bottom: AppTheme.space8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.payment,
                              color: AppTheme.success,
                              size: 20,
                            ),
                            SizedBox(width: AppTheme.space8),
                            Text(
                              'Payment Method',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.space16),
                        ...paymentMethods.map((method) {
                          final isSelected = selectedPayment == method['name'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPayment = method['name'];
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: AppTheme.space12),
                              padding: EdgeInsets.all(AppTheme.space12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusMedium,
                                ),
                                color: isSelected
                                    ? theme.colorScheme.primary.withOpacity(0.05)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    method['icon'],
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  SizedBox(width: AppTheme.space12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          method['name'],
                                          style: theme.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? theme.colorScheme.primary
                                                : null,
                                          ),
                                        ),
                                        SizedBox(height: AppTheme.space4),
                                        Text(
                                          method['subtitle'],
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: theme.colorScheme.primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  // Delivery Instructions
                  Container(
                    color: theme.colorScheme.surface,
                    padding: EdgeInsets.all(AppTheme.space16),
                    margin: EdgeInsets.only(bottom: AppTheme.space8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.note_alt_outlined,
                              color: AppTheme.warning,
                              size: 20,
                            ),
                            SizedBox(width: AppTheme.space8),
                            Text(
                              'Delivery Instructions (Optional)',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.space12),
                        TextField(
                          controller: instructionsController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Add delivery instructions...',
                            filled: true,
                            fillColor: isDark
                                ? AppTheme.darkSurfaceVariant
                                : AppTheme.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMedium,
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Order Summary
                  Container(
                    color: theme.colorScheme.surface,
                    padding: EdgeInsets.all(AppTheme.space16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppTheme.space12),
                        ...cartController.cartItems.map((cartItem) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: AppTheme.space4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${cartItem.quantity}x ${cartItem.foodItem.name}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                Text(
                                  '₹${(cartItem.foodItem.price * cartItem.quantity).toStringAsFixed(2)}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Price Bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: isDark ? AppTheme.darkShadowMedium : AppTheme.shadowMedium,
            ),
            padding: EdgeInsets.all(AppTheme.space16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Obx(() => Text(
                          '₹${cartController.total.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        )),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _placeOrder(context, cartController);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTheme.space24,
                          vertical: AppTheme.space16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Place Order',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: AppTheme.space8),
                          const Icon(Icons.check_circle, size: 20),
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
    );
  }

  void _placeOrder(BuildContext context, CartController cartController) {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      // Close loading
      Navigator.pop(context);

      // Create order details
      final orderDetails = {
        'items': cartController.cartItems.length,
        'total': cartController.total,
        'address': selectedAddress,
        'payment': selectedPayment,
        'instructions': instructionsController.text,
      };

      // Navigate to success screen
      // Get.off(() => OrderSuccessScreen(orderDetails: orderDetails));

      NavigationService.pushToOrderSuccess(orderDetails);


      // Clear cart
      cartController.clearCart();
    });
  }
}