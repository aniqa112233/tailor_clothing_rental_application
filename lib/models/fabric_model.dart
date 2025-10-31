class FabricModel {
  final String id;
  final String name;
  final String type;
  final String color;
  final int stock;
  final double price;
  final String imageUrl;

  FabricModel({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.stock,
    required this.price,
    required this.imageUrl,
  });

  factory FabricModel.fromJson(Map<String, dynamic> json) {
    return FabricModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      color: json['color'],
      stock: json['stock'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
    );
  }
}
