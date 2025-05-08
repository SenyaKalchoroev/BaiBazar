import 'package:baibazar_app/src/core/api/api_service.dart';
import 'package:baibazar_app/src/data/models/category_model.dart';

class CategoryRepository {
  final ApiService apiService;
  CategoryRepository({required this.apiService});

  Future<List<CategoryModel>> fetchCategories() async {
    final data = await apiService.getCategories();
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
