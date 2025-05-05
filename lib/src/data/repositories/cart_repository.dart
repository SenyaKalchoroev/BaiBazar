import '../../core/api/api_service.dart';
import '../models/cart_model.dart';

class CartRepository {
  final ApiService _api;
  CartRepository(this._api);

  Future<void> addToCart(int id) => _api.addToCart(id);

  Future<List<CartItemModel>> fetchCart() async {
    final raw = await _api.getCart();
    return raw.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }
  Future<void> clearCart() => _api.clearCart();
}