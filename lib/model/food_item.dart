class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  double rating;
  final Map<String, dynamic> nutrition;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.rating = 0.0,
    this.nutrition = const {'calories': 0, 'protein': 0, 'fat': 0},
  });
}
