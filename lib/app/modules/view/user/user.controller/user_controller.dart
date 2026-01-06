import 'package:get/get.dart';
import '../../../model/fooditem_model.dart';

class UserDashboardController extends GetxController {
  var selectedCategory = 0.obs;
  var searchQuery = ''.obs;

  final categories = [
    'All',
    'Pizza',
    'Burger',
    'Biryani',
    'Chinese',
    'South Indian',
  ];

  final foodItems = <FoodItem>[
    FoodItem(
      name: 'Margherita Pizza',
      restaurant: 'Pizza Hut',
      image: '🍕',
      price: 299,
      rating: 4.5,
      time: '30 min',
      tags: ['Italian', 'Cheese'],
      isVeg: true,
    ),
    FoodItem(
      name: 'Chicken Burger',
      restaurant: 'Burger King',
      image: '🍔',
      price: 199,
      rating: 4.3,
      time: '25 min',
      tags: ['Fast Food'],
      isVeg: false,
    ),
    FoodItem(
      name: 'Chicken Biryani',
      restaurant: 'Paradise Biryani',
      image: '🍛',
      price: 249,
      rating: 4.7,
      time: '40 min',
      tags: ['Indian', 'Spicy'],
      isVeg: false,
    ),
    FoodItem(
      name: 'Veg Hakka Noodles',
      restaurant: 'Chinese Wok',
      image: '🍜',
      price: 179,
      rating: 4.2,
      time: '35 min',
      tags: ['Chinese', 'Noodles'],
      isVeg: true,
    ),
    FoodItem(
      name: 'Masala Dosa',
      restaurant: 'Saravana Bhavan',
      image: '🥞',
      price: 89,
      rating: 4.6,
      time: '20 min',
      tags: ['South Indian', 'Crispy'],
      isVeg: true,
    ),
    FoodItem(
      name: 'Paneer Pizza',
      restaurant: 'Dominos',
      image: '🍕',
      price: 349,
      rating: 4.4,
      time: '30 min',
      tags: ['Italian', 'Paneer'],
      isVeg: true,
    ),
  ];

  void selectCategory(int index) {
    selectedCategory.value = index;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}
