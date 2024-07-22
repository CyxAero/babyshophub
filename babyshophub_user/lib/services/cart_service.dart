import 'package:BabyShopHub/models/cart_item_model.dart';
import 'package:BabyShopHub/services/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProductService _productService = ProductService();

  Future<void> saveCart(Map<String, CartItem> items) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final cartData = items.map((key, value) => MapEntry(key, {
          'productId': value.product.productId,
          'quantity': value.quantity,
        }));

    await _firestore.collection('carts').doc(userId).set({'items': cartData});
  }

  Future<Map<String, CartItem>> fetchCart() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return {};

    final doc = await _firestore.collection('carts').doc(userId).get();
    if (!doc.exists) return {};

    final data = doc.data() as Map<String, dynamic>;
    final itemsData = data['items'] as Map<String, dynamic>;

    final items = <String, CartItem>{};
    for (final entry in itemsData.entries) {
      final productId = entry.value['productId'] as String;
      final quantity = entry.value['quantity'] as int;
      final product = await _productService.getProductById(productId);
      items[productId] = CartItem(product: product, quantity: quantity);
    }

    return items;
  }
}