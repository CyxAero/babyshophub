import 'package:BabyShopHub/models/cart_item_model.dart';
import 'package:BabyShopHub/services/cart_service.dart';
import 'package:flutter/foundation.dart';
import 'package:BabyShopHub/models/product_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  final CartService _cartService = CartService();
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

  Future<void> clear() async {
    _items = {};
    await _cartService.saveCart(_items);
    notifyListeners();
  }
}