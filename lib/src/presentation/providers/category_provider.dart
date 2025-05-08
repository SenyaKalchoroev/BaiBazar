import 'package:flutter/material.dart';
import 'package:baibazar_app/src/data/models/category_model.dart';
import 'package:baibazar_app/src/data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository repository;
  CategoryProvider({required this.repository});

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadCategories() async {
    try {
      _isLoading = true;
      notifyListeners();
      _categories = await repository.fetchCategories();
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Не удалось загрузить категории: $e';
      notifyListeners();
    }
  }
}
