import 'package:baibazar_app/src/core/api/api_service.dart';
import 'package:baibazar_app/src/data/models/product_model.dart';

class ProductRepository {
  final ApiService apiService;
  ProductRepository({required this.apiService});

  Future<List<ProductModel>> fetchProducts() async {
    final data = await apiService.getProducts();
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<List<ProductModel>> fetchProductsByTag(String tag) async {
    final data = await apiService.getProductsByTag(tag);
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> fetchProductById(int id) async {
    final data = await apiService.getProductById(id);
    return ProductModel.fromJson(data);
  }
}
