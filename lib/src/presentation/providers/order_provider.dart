import 'package:flutter/foundation.dart';
import '../../data/models/order_summary.dart';
import '../../data/models/order_detail.dart';
import '../../data/repositories/order_repository.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository repo;
  OrderProvider(this.repo);

  bool isLoading = false;
  int selectedStatus = 1;
  List<OrderSummary> orders = [];
  OrderDetail? detail;

  Future<void> createOrder({
    required String street,
    required String homeAdress,
    required String phonenumber,
    required String commentToOrder,
  }) async {
    isLoading = true;
    notifyListeners();
    await repo.createOrder(
      street: street,
      homeAdress: homeAdress,
      phonenumber: phonenumber,
      commentToOrder: commentToOrder,
    );
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadOrders(int status) async {
    selectedStatus = status;
    isLoading = true;
    notifyListeners();
    orders = await repo.fetchOrders(status: status);
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadOrderDetail(int id) async {
    isLoading = true;
    notifyListeners();
    detail = await repo.fetchOrderDetail(id);
    isLoading = false;
    notifyListeners();
  }
}
