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
    final body = json.decode(res.body) as Map<String, dynamic>;
    await _saveToken(body['access_token'] as String);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(
      Uri.parse('$_base/user/profile/'),
      headers: _headers(),
    );
    _check(res);
    final body = json.decode(res.body) as Map<String, dynamic>;
    return (body['data'] as Map<String, dynamic>);
  }


  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> d) async {
    final res = await http.put(
      Uri.parse('$_base/user/profile/'),
      headers: _headers(),
      body: json.encode(d),
    );
    _check(res);
    return json.decode(res.body) as Map<String, dynamic>;
  }

  Future<void> addToCart(int productId) async {
    final res = await http.post(
      Uri.parse('$_base/cart/?product_id=$productId'),
      headers: _headers(),
    );
    _check(res);
  }

  Future<List<dynamic>> getCart() async {
    final res = await http.get(
      Uri.parse('$_base/cart/'),
      headers: _headers(),
    );
    _check(res);
    return json.decode(res.body) as List<dynamic>;
  }

  Future<void> clearCart() async {
    final res = await http.delete(
      Uri.parse('$_base/cart/'),
      headers: _headers(),
    );
    _check(res);
  }

  Future<List<dynamic>> getCategories() async {
    final res = await http.get(
      Uri.parse('$_base/product/category/'),
      headers: _headers(),
    );
    _check(res);
    return json.decode(res.body) as List<dynamic>;
  }

  Future<List<dynamic>> getProducts() async {
    final res = await http.get(
      Uri.parse('$_base/product/'),
      headers: _headers(),
    );
    _check(res);
    return json.decode(res.body) as List<dynamic>;
  }

  Future<List<dynamic>> getProductsByTag(String tag) async {
    final res = await http.get(
      Uri.parse('$_base/product/?tag=$tag'),
      headers: _headers(),
    );
    _check(res);
    return json.decode(res.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    final res = await http.get(
      Uri.parse('$_base/product/$id/'),
      headers: _headers(),
    );
    _check(res);
    return json.decode(res.body) as Map<String, dynamic>;
  }
}
