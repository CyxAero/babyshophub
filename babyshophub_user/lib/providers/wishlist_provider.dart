import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BabyShopHub/models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _savedProducts = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ProductModel> get savedProducts => _savedProducts;

  WishlistProvider() {
    _loadSavedProducts();
  }

  Future<void> _loadSavedProducts() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .get();

      _savedProducts.clear();
      for (var doc in snapshot.docs) {
        _savedProducts.add(ProductModel.fromFirestore(doc));
      }
      notifyListeners();
    }
  }

  bool isProductSaved(ProductModel product) {
    return _savedProducts
        .any((savedProduct) => savedProduct.productId == product.productId);
  }

  Future<void> toggleSavedProduct(ProductModel product) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (isProductSaved(product)) {
      _savedProducts.removeWhere(
          (savedProduct) => savedProduct.productId == product.productId);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(product.productId)
          .delete();
    } else {
      _savedProducts.add(product);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(product.productId)
          .set(product.toFirestore());
    }
    notifyListeners();
  }
}