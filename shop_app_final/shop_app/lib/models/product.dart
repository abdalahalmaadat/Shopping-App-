class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isNew;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    this.isNew = false,
    this.isFavorite = false,
  });

  double get discountPercent =>
      ((originalPrice - price) / originalPrice * 100).roundToDouble();

  bool get hasDiscount => originalPrice > price;
}
