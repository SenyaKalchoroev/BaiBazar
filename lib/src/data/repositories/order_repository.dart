import '../../core/api/api_service.dart';
import '../models/order_detail.dart';
import '../models/order_summary.dart';

class OrderRepository {
  final ApiService api;
  OrderRepository(this.api);

  Future<void> createOrder({
    required String street,
    required String homeAdress,
    required String phonenumber,
    required String commentToOrder,
  }) =>
      api.createOrder(
        street: street,
        homeAdress: homeAdress,
        phonenumber: phonenumber,
        commentToOrder: commentToOrder,
      );

  Future<List<OrderSummary>> fetchOrders({required int status}) async {
    final raw = await api.getOrders(status: status);
    return raw
        .cast<Map<String, dynamic>>()
        .map((m) => OrderSummary.fromJson(m))
        .toList();
  }

  Future<OrderDetail> fetchOrderDetail(int id) async {
    final data = await api.getOrderDetail(id);
    return OrderDetail.fromJson(data);
  }
}
