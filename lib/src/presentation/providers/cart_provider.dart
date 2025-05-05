// lib/src/presentation/providers/cart_provider.dart

import 'package:flutter/foundation.dart';
import '../../data/models/cart_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repo;
  CartProvider(this._repo);

  bool isLoading = false;
  List<CartItemModel> items = [];

  Future<void> loadCart() async {
    isLoading = true;
    notifyListeners();

    try {
      final fetched = await _repo.fetchCart();
      items = fetched;
    } catch (e) {
      debugPrint('❌ loadCart error: $e');
      items = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(int productId) async {
    await _repo.addToCart(productId);
    await loadCart();
  }
}
