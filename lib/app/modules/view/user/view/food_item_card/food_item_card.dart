// import 'package:flutter/material.dart';
// import '../../../../../core/theme/app_theme.dart';
// import '../../../../model/fooditem_model.dart';
//
// class FoodItemCard extends StatelessWidget {
//   final FoodItem item;
//
//   const FoodItemCard({super.key, required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: AppTheme.space16),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
//         boxShadow: isDark ? AppTheme.darkShadowMedium : AppTheme.shadowMedium,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image Section
//           Stack(
//             children: [
//               Container(
//                 height: 180,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(AppTheme.radiusLarge),
//                   ),
//                   gradient: LinearGradient(
//                     colors: [
//                       AppTheme.accent.withOpacity(0.7),
//                       AppTheme.primary,
//                     ],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     item.image,
//                     style: const TextStyle(fontSize: 80),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 12,
//                 left: 12,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: AppTheme.space8,
//                     vertical: AppTheme.space4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: item.isVeg ? AppTheme.success : AppTheme.error,
//                     borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
//                   ),
//                   child: Text(
//                     item.isVeg ? 'VEG' : 'NON-VEG',
//                     style: theme.textTheme.labelSmall?.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: Container(
//                   padding: EdgeInsets.all(AppTheme.space8),
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.surface,
//                     shape: BoxShape.circle,
//                     boxShadow: isDark
//                         ? AppTheme.darkShadowSmall
//                         : AppTheme.shadowSmall,
//                   ),
//                   child: Icon(
//                     Icons.favorite_border,
//                     size: 20,
//                     color: AppTheme.error,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // Content Section
//           Padding(
//             padding: EdgeInsets.all(AppTheme.space16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.name,
//                   style: theme.textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: AppTheme.space4),
//                 Text(
//                   item.restaurant,
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.onSurface.withOpacity(0.6),
//                   ),
//                 ),
//                 SizedBox(height: AppTheme.space8),
//                 Wrap(
//                   spacing: AppTheme.space8,
//                   children: item.tags
//                       .map(
//                         (tag) => Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: AppTheme.space8,
//                         vertical: AppTheme.space4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? AppTheme.darkSurfaceVariant
//                             : AppTheme.surfaceVariant,
//                         borderRadius: BorderRadius.circular(
//                           AppTheme.radiusSmall,
//                         ),
//                       ),
//                       child: Text(
//                         tag,
//                         style: theme.textTheme.labelSmall?.copyWith(
//                           color: theme.colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                   )
//                       .toList(),
//                 ),
//                 SizedBox(height: AppTheme.space12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.star,
//                           color: AppTheme.warning,
//                           size: 18,
//                         ),
//                         SizedBox(width: AppTheme.space4),
//                         Text(
//                           '${item.rating}',
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: AppTheme.space16),
//                         Icon(
//                           Icons.access_time,
//                           color: theme.colorScheme.onSurface.withOpacity(0.6),
//                           size: 18,
//                         ),
//                         SizedBox(width: AppTheme.space4),
//                         Text(
//                           item.time,
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             color: theme.colorScheme.onSurface.withOpacity(0.6),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           '₹${item.price}',
//                           style: theme.textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: AppTheme.space12),
//                         ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: theme.colorScheme.primary,
//                             foregroundColor: theme.colorScheme.onPrimary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                 AppTheme.radiusSmall,
//                               ),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: AppTheme.space16,
//                               vertical: AppTheme.space8,
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             'ADD',
//                             style: theme.textTheme.labelMedium?.copyWith(
//                               color: theme.colorScheme.onPrimary,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../model/fooditem_model.dart';
import '../../user.controller/cart_controller.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;

  const FoodItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cartController = Get.find<CartController>();

    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.space16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: isDark ? AppTheme.darkShadowMedium : AppTheme.shadowMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusLarge),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accent.withOpacity(0.7),
                      AppTheme.primary,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    item.image,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.space8,
                    vertical: AppTheme.space4,
                  ),
                  decoration: BoxDecoration(
                    color: item.isVeg ? AppTheme.success : AppTheme.error,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    item.isVeg ? 'VEG' : 'NON-VEG',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.all(AppTheme.space8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: isDark
                        ? AppTheme.darkShadowSmall
                        : AppTheme.shadowSmall,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: AppTheme.error,
                  ),
                ),
              ),
            ],
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(AppTheme.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppTheme.space4),
                Text(
                  item.restaurant,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: AppTheme.space8),
                Wrap(
                  spacing: AppTheme.space8,
                  children: item.tags
                      .map(
                        (tag) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.space8,
                        vertical: AppTheme.space4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.darkSurfaceVariant
                            : AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
                SizedBox(height: AppTheme.space12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppTheme.warning,
                          size: 18,
                        ),
                        SizedBox(width: AppTheme.space4),
                        Text(
                          '${item.rating}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: AppTheme.space16),
                        Icon(
                          Icons.access_time,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          size: 18,
                        ),
                        SizedBox(width: AppTheme.space4),
                        Text(
                          item.time,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '₹${item.price}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: AppTheme.space12),

                        // Add/Update Cart Button
                        Obx(() {
                          final quantity = cartController.getQuantity(item);

                          if (quantity == 0) {
                            // Show ADD button
                            return ElevatedButton(
                              onPressed: () => cartController.addToCart(item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusSmall,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppTheme.space16,
                                  vertical: AppTheme.space8,
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'ADD',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          } else {
                            // Show quantity controls
                            final cartItem = cartController.cartItems
                                .firstWhere((ci) => ci.foodItem.name == item.name);

                            return Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusSmall,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => cartController.decreaseQuantity(cartItem),
                                    icon: Icon(
                                      quantity == 1 ? Icons.delete_outline : Icons.remove,
                                      color: theme.colorScheme.onPrimary,
                                      size: 20,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppTheme.space8,
                                    ),
                                    child: Text(
                                      '$quantity',
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => cartController.increaseQuantity(cartItem),
                                    icon: Icon(
                                      Icons.add,
                                      color: theme.colorScheme.onPrimary,
                                      size: 20,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                      ],
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
}