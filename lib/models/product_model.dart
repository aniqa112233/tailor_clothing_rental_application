class ProductModel {
  final String id;
  final String title;
  final String category;
  final String size;
  final double pricePerDay;
  final bool availability;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.size,
    required this.pricePerDay,
    required this.availability,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      size: json['size'],
      pricePerDay: (json['price_per_day'] as num).toDouble(),
      availability: json['availability'],
      imageUrl: json['image_url'],
    );
  }
}
