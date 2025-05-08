class CartItemModel {
  final int id;            // ID записи в корзине
  final int productId;     // ID продукта
  final String title;
  final String imageUrl;   // полный URL
  final String weight;     // «1.23кг»
  final String price;      // «415.54c»

  CartItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.weight,
    required this.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>;
    final images = (product['product'] as List).cast<Map<String, dynamic>>();
    final relPath = images.isNotEmpty ? images[0]['image'] as String : '';
    final fullUrl = 'https://baibazar.pp.ua$relPath';

    final w = product['weight'] != null ? '${product['weight']}кг' : '';
    final p = '${product['price']}c';

    return CartItemModel(
      id: json['id'] as int,
      productId: product['id'] as int,
      title: product['title'] as String,
      imageUrl: fullUrl,
      weight: w,
      price: p,
    );
  }
}
