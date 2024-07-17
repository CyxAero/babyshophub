import 'package:babyshophub_admin/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _products = [];
  final Map<String, ProductModel> _productCache = {};

  List<ProductModel> get products => _products;

  Future<void> fetchProducts() async {
    if (_productCache.isNotEmpty) {
      _products.clear();
      _products.addAll(_productCache.values);
      notifyListeners();
      return;
    }

    final querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();
    final products = querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();

    _productCache.clear();
    for (var product in products) {
      _productCache[product.productId] = product;
    }

    _products.clear();
    _products.addAll(products);
    notifyListeners();
  }

  Future<void> addProduct(ProductModel product) async {
    final docRef = await FirebaseFirestore.instance
        .collection('products')
        .add(product.toFirestore());
    product.productId = docRef.id;
    _productCache[product.productId] = product;
    _products.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product.productId)
        .update(product.toFirestore());
    _productCache[product.productId] = product;

    final index = _products.indexWhere((p) => p.productId == product.productId);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
    _productCache.remove(productId);

    _products.removeWhere((product) => product.productId == productId);
    notifyListeners();
  }

  Future<ProductModel?> getProductById(String productId) async {
    if (_productCache.containsKey(productId)) {
      return _productCache[productId];
    }

    final docSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
    if (docSnapshot.exists) {
      final product = ProductModel.fromFirestore(docSnapshot);
      _productCache[productId] = product;
      return product;
    } else {
      // Handle product not found
      return null; // Or throw an exception
    }
  }

  // Future<void> addReview(String productId, ReviewModel review) async {
  //   final product = await getProductById(productId);
  //   if (product != null) {
  //     product.reviews.add(review);
  //     await updateProduct(product);
  //     notifyListeners();
  //   }
  // }

  // Future<void> updateReview(String productId, ReviewModel review) async {
  //   final product = await getProductById(productId);
  //   if (product != null) {
  //     final reviewIndex =
  //         product.reviews.indexWhere((r) => r.reviewId == review.reviewId);
  //     if (reviewIndex != -1) {
  //       product.reviews[reviewIndex] = review;
  //       await updateProduct(product);
  //       notifyListeners();
  //     }
  //   }
  // }

  Future<void> deleteReview(String productId, String reviewId) async {
    final product = await getProductById(productId);
    if (product != null) {
      product.reviews.removeWhere((review) => review.reviewId == reviewId);
      await updateProduct(product);
      notifyListeners();
    }
  }
}
