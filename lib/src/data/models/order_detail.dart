// lib/src/data/models/order_detail.dart

class OrderDetail {
  final int id;
  final double totalPrice;
  final String status;
  final String? fullName;
  final String? phone;
  final String comment;
  final DateTime date;
  final List<int> itemIds;

  OrderDetail({
    required this.id,
    required this.totalPrice,
    required this.status,
    this.fullName,
    this.phone,
    required this.comment,
    required this.date,
    required this.itemIds,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] as int,
      totalPrice: double.parse(json['total_price'].toString()),
      status: json['get_status'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phonenumber'] as String?,
      comment: json['comment_to_order'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      itemIds: (json['items'] as List)
          .cast<Map<String, dynamic>>()
          .map((m) => m['product'] as int)
          .toList(),
    );
  }
}
