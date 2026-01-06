import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Model
class FoodItem {
  final String name;
  final String restaurant;
  final String image;
  final double price;
  final double rating;
  final String time;
  final List<String> tags;
  final bool isVeg;

  FoodItem({
    required this.name,
    required this.restaurant,
    required this.image,
    required this.price,
    required this.rating,
    required this.time,
    required this.tags,
    required this.isVeg,
  });
}

// Controller
class DashboardController extends GetxController {
  var selectedCategory = 0.obs;
  var searchQuery = ''.obs;

  final categories = [
    'All',
    'Pizza',
    'Burger',
    'Biryani',
    'Chinese',
    'South Indian'
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

// Main Dashboard Widget
class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.red[700], size: 20),
            const SizedBox(width: 4),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Pune, Maharashtra',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: 'Search for dishes, restaurants...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Category Tabs
          Container(
            height: 50,
            color: Colors.white,
            child:  ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final isSelected = controller.selectedCategory.value == index;
                return GestureDetector(
                  onTap: () => controller.selectCategory(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red[700] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        controller.categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
              padding: const EdgeInsets.all(16),
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

// Food Item Card Widget
class FoodItemCard extends StatelessWidget {
  final FoodItem item;

  const FoodItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [Colors.orange[300]!, Colors.red[300]!],
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.isVeg ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.isVeg ? 'VEG' : 'NON-VEG',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite_border, size: 20, color: Colors.red[700]),
                ),
              ),
            ],
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.restaurant,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: item.tags
                      .map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(fontSize: 11, color: Colors.black87),
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[700], size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${item.rating}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time, color: Colors.grey[600], size: 18),
                        const SizedBox(width: 4),
                        Text(
                          item.time,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '₹${item.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            'ADD',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
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