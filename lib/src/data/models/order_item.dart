class OrderItem {
  final int id;
  final int productId;

  OrderItem({required this.id, required this.productId});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      productId: json['product'] as int,
    );
  }
}