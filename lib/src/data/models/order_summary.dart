class OrderSummary {
  final int id;
  final String totalPrice;
  final String getStatus;
  final String date;

  OrderSummary({
    required this.id,
    required this.totalPrice,
    required this.getStatus,
    required this.date,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      id: json['id'] as int,
      totalPrice: json['total_price'].toString(),
      getStatus: json['get_status'] as String,
      date: json['date'] as String,
    );
  }
}
