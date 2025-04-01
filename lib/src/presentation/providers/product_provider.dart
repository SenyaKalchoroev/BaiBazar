import 'package:flutter/material.dart';
import 'package:baibazar_app/src/data/models/product_model.dart';
import 'package:baibazar_app/src/data/repositories/products_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;
  ProductProvider({required this.repository});

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<ProductModel> get products => _filteredProducts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _sortByNewest = true;
  bool get sortByNewest => _sortByNewest;

  String? _error;
  String? get error => _error;

  ProductModel? _selectedProduct;
  ProductModel? get selectedProduct => _selectedProduct;

  bool _isLoadingSingle = false;
  bool get isLoadingSingle => _isLoadingSingle;

  String? _singleProductError;
  String? get singleProductError => _singleProductError;

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      notifyListeners();
      _allProducts = await repository.fetchProducts();
      _filteredProducts = List.from(_allProducts);
      _error = null;
    } catch (e) {
      _error = 'Ошибка при загрузке продуктов: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProductsByTag(String tag) async {
    try {
      _isLoading = true;
      notifyListeners();
      _allProducts = await repository.fetchProductsByTag(tag);
      _filteredProducts = List.from(_allProducts);
      _error = null;
    } catch (e) {
      _error = 'Ошибка при загрузке продуктов по тегу: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final lower = query.toLowerCase();
      _filteredProducts = _allProducts.where(
            (p) => p.title.toLowerCase().contains(lower),
      ).toList();
    }
    notifyListeners();
  }

  void toggleSortByDate() {
    _sortByNewest = !_sortByNewest;
    if (_sortByNewest) {
      _filteredProducts.sort((a, b) => b.date.compareTo(a.date));
    } else {
      _filteredProducts.sort((a, b) => a.date.compareTo(b.date));
    }
    notifyListeners();
  }

  Future<void> loadSingleProduct(int id) async {
    try {
      _isLoadingSingle = true;
      notifyListeners();
      _selectedProduct = await repository.fetchProductById(id);
      _singleProductError = null;
    } catch (e) {
      _singleProductError = 'Ошибка при получении продукта $id: $e';
    }
    _isLoadingSingle = false;
    notifyListeners();
  }
}
