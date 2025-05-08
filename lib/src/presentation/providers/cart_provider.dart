import 'package:flutter/foundation.dart';
import '../../data/models/cart_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repo;
  CartProvider(this._repo);

  bool isLoading = false;
  List<CartItemModel> items = [];
  double fullPrice = 0.0;

  Future<void> loadCart() async {
    isLoading = true;
    notifyListeners();
    try {
      final resp = await _repo.fetchCart();
      items = resp.items;
      fullPrice = resp.fullPrice;
    } catch (e) {
      items = [];
      fullPrice = 0.0;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(int productId) async {
    await _repo.addToCart(productId);
    await loadCart();
  }

  Future<void> removeFromCart(int cartId) async {
    await _repo.removeFromCart(cartId);
    await loadCart();
  }
}
