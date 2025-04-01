class ProductModel {
  final int id;
  final String title;
  final String description;
  final String? weight;
  final String price;
  final DateTime date;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.weight,
    required this.price,
    required this.date,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final productList = json['product'] as List<dynamic>?;
    final images = productList != null
        ? productList.map((item) => item['image'] as String).toList()
        : <String>[];

    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      weight: json['weight'] as String?,
      price: json['price'] as String,
      date: DateTime.parse(json['date']),
      images: images,
    );
  }
}
