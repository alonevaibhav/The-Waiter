import 'package:get/get.dart';
import '../../../model/cart_model.dart';
import '../../../model/fooditem_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  // Add item to cart
  void addToCart(FoodItem foodItem) {
    // Check if item already exists in cart
    final existingIndex = cartItems.indexWhere((item) => item.foodItem.name == foodItem.name);

    if (existingIndex >= 0) {
      // Item exists, increase quantity
      cartItems[existingIndex].quantity++;
      cartItems.refresh();
    } else {
      // Add new item
      cartItems.add(CartItem(foodItem: foodItem, quantity: 1));
    }

    Get.snackbar(
      'Added to Cart',
      '${foodItem.name} added successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Remove item from cart
  void removeFromCart(CartItem cartItem) {
    cartItems.remove(cartItem);
    Get.snackbar(
      'Removed',
      '${cartItem.foodItem.name} removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Increase quantity
  void increaseQuantity(CartItem cartItem) {
    final index = cartItems.indexOf(cartItem);
    if (index >= 0) {
      cartItems[index].quantity++;
      cartItems.refresh();
    }
  }

  // Decrease quantity
  void decreaseQuantity(CartItem cartItem) {
    final index = cartItems.indexOf(cartItem);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        removeFromCart(cartItem);
      }
    }
  }

  // Calculate subtotal
  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + (item.foodItem.price * item.quantity));
  }

  // Calculate taxes (5% GST)
  double get taxes {
    return subtotal * 0.05;
  }

  // Delivery fee
  double get deliveryFee {
    return subtotal > 0 ? 40.0 : 0.0;
  }

  // Platform fee
  double get platformFee {
    return subtotal > 0 ? 5.0 : 0.0;
  }

  // Total amount
  double get total {
    return subtotal + taxes + deliveryFee + platformFee;
  }

  // Total items count
  int get itemCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
  }

  // Check if item is in cart
  bool isInCart(FoodItem foodItem) {
    return cartItems.any((item) => item.foodItem.name == foodItem.name);
  }

  // Get quantity of specific item
  int getQuantity(FoodItem foodItem) {
    final cartItem = cartItems.firstWhereOrNull((item) => item.foodItem.name == foodItem.name);
    return cartItem?.quantity ?? 0;
  }
}