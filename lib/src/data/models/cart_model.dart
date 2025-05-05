class CartItemModel {
  final int productId;
  final String title;
  final String image;
  final String weight;
  final String price;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.image,
    required this.weight,
    required this.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product']['id'],
      title: json['product']['title'],
      image: json['product']['images'][0],
      weight: json['product']['weight'] ?? '',
      price: json['product']['price'],
    );
  }
}


