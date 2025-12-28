// lib/models/todo.dart
class MenuItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final bool isAvailable;
  final bool isSpecialOffer;
  final String? imageUrl;
  final String? description;
  final int? discountPercent;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.isAvailable = true,
    this.isSpecialOffer = false,
    this.imageUrl,
    this.description,
    this.discountPercent,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'price': price,
    'isAvailable': isAvailable,
    'isSpecialOffer': isSpecialOffer,
    'imageUrl': imageUrl,
    'description': description,
    'discountPercent': discountPercent,
  };

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    price: json['price'],
    isAvailable: json['isAvailable'] ?? true,
    isSpecialOffer: json['isSpecialOffer'] ?? false,
    imageUrl: json['imageUrl'],
    description: json['description'],
    discountPercent: json['discountPercent'],
  );

  MenuItem copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    bool? isAvailable,
    bool? isSpecialOffer,
    String? imageUrl,
    String? description,
    int? discountPercent,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      isSpecialOffer: isSpecialOffer ?? this.isSpecialOffer,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}
