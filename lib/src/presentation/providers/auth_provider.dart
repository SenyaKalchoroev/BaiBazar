/*
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://baibazar.pp.ua/api/v1';

  Future<List<dynamic>> getCategories() async {
    final url = Uri.parse('$baseUrl/product/category/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List;
    } else {
      throw Exception('Ошибка при получении категорий: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getProducts() async {
    final url = Uri.parse('$baseUrl/product/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List;
    } else {
      throw Exception('Ошибка при получении продуктов: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getProductsByTag(String tag) async {
    final url = Uri.parse('$baseUrl/product/?tag=$tag');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List;
    } else {
      throw Exception('Ошибка при получении продуктов по тегу: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    final url = Uri.parse('$baseUrl/product/$id/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Ошибка при получении продукта $id: ${response.statusCode}');
    }
  }
}*/
