import 'dart:math';

import 'package:BabyShopHub/models/cart_item_model.dart';
import 'package:BabyShopHub/services/cart_service.dart';
import 'package:BabyShopHub/services/product_service.dart';
import 'package:flutter/foundation.dart';
import 'package:BabyShopHub/models/product_model.dart';
import 'package:logger/logger.dart';

class MockPaymentService {
  // Simulate a payment process
  static Future<bool> processPayment({required double amount}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate a success rate of 100%
    return Random().nextDouble() < 1;
  }
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService();
  bool _isLoading = false;

  CartProvider() {
    _loadCart();
  }

  bool get isLoading => _isLoading;

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> _loadCart() async {
    _isLoading = true;
    notifyListeners();
    _items = await _cartService.fetchCart();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(ProductModel product, int quantity) async {
    if (_items.containsKey(product.productId)) {
      _items.update(
        product.productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.productId,
        () => CartItem(product: product, quantity: quantity),
      );
    }
    await _cartService.saveCart(_items);
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    _items.remove(productId);
    await _cartService.saveCart(_items);
    notifyListeners();
  }

  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    await _cartService.saveCart(_items);
    notifyListeners();
  }

  Future<bool> processPayment() async {
    try {
      bool paymentSuccess = await MockPaymentService.processPayment(
        amount: totalAmount,
      );

      if (paymentSuccess) {
        // Payment successful, update product stock
        await _updateProductStock();
        // Clear the cart
        await clear();
        return true;
      } else {
        Logger().e('Payment failed');
        return false;
      }
    } catch (e) {
      Logger().e('Error processing payment: $e');
      return false;
    }
  }

  Future<void> _updateProductStock() async {
    for (var item in _items.values) {
      await _productService.updateProductStock(
        item.product.productId,
        item.product.stock - item.quantity,
      );
    }
  }

  Future<void> clear() async {
    _items = {};
    await _cartService.saveCart(_items);
    notifyListeners();
  }
}
