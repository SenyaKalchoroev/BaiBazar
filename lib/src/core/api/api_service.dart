import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const _base = 'https://baibazar.pp.ua/api/v1';
  String? _token;

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    _token = sp.getString('bb_token');
  }

  bool get isAuthorized => _token != null;

  Future<void> _saveToken(String t) async {
    _token = t;
    final sp = await SharedPreferences.getInstance();
    await sp.setString('bb_token', t);
  }

  Future<void> clearToken() async {
    _token = null;
    final sp = await SharedPreferences.getInstance();
    await sp.remove('bb_token');
  }

  Map<String, String> _headers({bool auth = true}) => {
    'Content-Type': 'application/json',
    if (auth && _token != null) 'Authorization': 'Bearer $_token',
  };

  void _check(http.Response r) {
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw Exception('[${r.statusCode}] ${r.body}');
    }
  }

  Future<void> registerAuthenticate({
    required String idToken,
    required String phone,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/user/register-authenticate/'),
      headers: _headers(auth: false),
      body: json.encode({
        'id_token': idToken,
        'phonenumber': phone,
      }),
    );
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    final body = json.decode(decoded) as Map<String, dynamic>;

    await _saveToken(body['access_token'] as String);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(
      Uri.parse('$_base/user/profile/'),
      headers: _headers(),
    );
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    final body = json.decode(decoded) as Map<String, dynamic>;

    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> d) async {
    final res = await http.put(
      Uri.parse('$_base/user/profile/'),
      headers: _headers(),
      body: json.encode(d),
    );
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    return json.decode(decoded) as Map<String, dynamic>;
  }

  Future<void> addToCart(int productId) async {
    final res = await http.post(
      Uri.parse('$_base/cart/?product_id=$productId'),
      headers: _headers(),
    );
    _check(res);
  }

  Future<Map<String, dynamic>> getCartWithMeta() async {
    final res = await http.get(
      Uri.parse('$_base/cart/'),
      headers: _headers(),
    );
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    return json.decode(decoded) as Map<String, dynamic>;
  }

  Future<void> deleteCartItem(int cartId) async {
    final res = await http.delete(
      Uri.parse('$_base/cart/?cart_id=$cartId'),
      headers: _headers(),
    );
    _check(res);
  }

  Future<void> createOrder({
    required String street,
    required String homeAdress,
    required String phonenumber,
    required String commentToOrder,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/order/create/'),
      headers: _headers(),
      body: json.encode({
        'street': street,
        'home_adress': homeAdress,
        'phonenumber': phonenumber,
        'comment_to_order': commentToOrder,
      }),
    );
    _check(res);
  }

  Future<List<dynamic>> getOrders({int? status}) async {
    final uri = status != null
        ? Uri.parse('$_base/order/get/?status=$status')
        : Uri.parse('$_base/order/get/');
    final res = await http.get(uri, headers: _headers());
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    return json.decode(decoded) as List<dynamic>;
  }

  Future<Map<String, dynamic>> getOrderDetail(int id) async {
    final res = await http.get(
      Uri.parse('$_base/order/retrieve/$id/'),
      headers: _headers(),
    );
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    return json.decode(decoded) as Map<String, dynamic>;
  }

  Future<List<dynamic>> getCategories() async {
    final res = await http.get(
      Uri.parse('$_base/product/category/'),
      headers: _headers(),
    );
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    return json.decode(decoded) as List<dynamic>;
  }

  Future<List<dynamic>> getProducts() async {
    final res = await http.get(
      Uri.parse('$_base/product/'),
      headers: _headers(),
    );
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    return json.decode(decoded) as List<dynamic>;
  }

  Future<List<dynamic>> getProductsByTag(String tag) async {
    final res = await http.get(
      Uri.parse('$_base/product/?tag=$tag'),
      headers: _headers(),
    );
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    return json.decode(decoded) as List<dynamic>;
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    final res = await http.get(
      Uri.parse('$_base/product/$id/'),
      headers: _headers(),
    );
    _check(res);

    final decoded = utf8.decode(res.bodyBytes);
    return json.decode(decoded) as Map<String, dynamic>;
  }
}
