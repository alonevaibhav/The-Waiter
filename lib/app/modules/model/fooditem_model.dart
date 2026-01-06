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