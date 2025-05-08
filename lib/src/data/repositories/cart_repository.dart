import '../../core/api/api_service.dart';
import '../models/cart_model.dart';

class CartResponse {
  final List<CartItemModel> items;
  final double fullPrice;
  CartResponse({required this.items, required this.fullPrice});
}

class CartRepository {
  final ApiService _api;
  CartRepository(this._api);

  Future<CartResponse> fetchCart() async {
    final raw = await _api.getCartWithMeta();
    final list = (raw['data'] as List).cast<Map<String, dynamic>>();
    final items = list.map((j) => CartItemModel.fromJson(j)).toList();
    final fullPrice = (raw['full_price'] as num).toDouble();
    return CartResponse(items: items, fullPrice: fullPrice);
  }

  Future<void> addToCart(int productId) => _api.addToCart(productId);
  Future<void> removeFromCart(int cartId) => _api.deleteCartItem(cartId);
}
