import 'package:BabyShopHub/models/category_model.dart';
import 'package:BabyShopHub/models/product_model.dart';
import 'package:BabyShopHub/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  ProductProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
      _categories = await _productService.getCategories();
    } catch (error) {
      print('Error loading data: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await _loadData();
  }

  List<ProductModel> getFilteredProducts(String? category) {
    if (category == null || category == 'All') {
      return _products;
    }
    return _products
        .where((product) => product.categories.contains(category))
        .toList();
  }
}