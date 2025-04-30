import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const _base = 'https://baibazar.pp.ua/api/v1';

  String? _token;

  /// Загружает сохранённый токен (если есть).
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

  Map<String, String> _headers({bool auth = true}) {
    return {
      'Content-Type': 'application/json',
      if (auth && _token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<dynamic> _get(String path) async {
    final res = await http.get(
      Uri.parse('$_base$path'),
      headers: _headers(auth: true),
    );
    _check(res);
    return json.decode(res.body);
  }

  Future<dynamic> _post(String path, Map body, {bool auth = true}) async {
    final res = await http.post(
      Uri.parse('$_base$path'),
      headers: _headers(auth: auth),
      body: json.encode(body),
    );
    _check(res);
    return json.decode(res.body);
  }

  Future<dynamic> _put(String path, Map body) async {
    final url = '$_base$path';
    final headers = _headers(auth: true);
    final payload = json.encode(body);

    print('>> PUT URL     = $url');
    print('>> PUT TOKEN   = $_token');
    print('>> PUT HEADERS = $headers');
    print('>> PUT BODY    = $payload');

    final res = await http.put(
      Uri.parse(url),
      headers: headers,
      body: payload,
    );

    print('>> PUT RESP_CODE = ${res.statusCode}');
    print('>> PUT RESP_BODY = ${res.body}');

    _check(res);
    return json.decode(res.body);
  }


  void _check(http.Response r) {
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw Exception('[${r.statusCode}] ${r.body}');
    }
  }

  Future<void> registerPhone(String phone) =>
      _post('/user/register/', {'phonenumber': phone}, auth: false);

  Future<void> verifyCode(String phone, String code) async {
    final res = await _post(
      '/user/verify/',
      {'phonenumber': phone, 'otp_code': code},
      auth: false,
    ) as Map<String, dynamic>;
    await _saveToken(res['access_token'] as String);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final res = await _get('/user/profile/');
    return res as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> data) async {
    final res = await _put('/user/profile/', data);
    return res as Map<String, dynamic>;
  }

  Future<List<dynamic>> getCategories() async =>
      await _get('/product/category/') as List;

  Future<List<dynamic>> getProducts() async =>
      await _get('/product/') as List;

  Future<List<dynamic>> getProductsByTag(String tag) async =>
      await _get('/product/?tag=$tag') as List;

  Future<Map<String, dynamic>> getProductById(int id) async =>
      await _get('/product/$id/') as Map<String, dynamic>;
}
