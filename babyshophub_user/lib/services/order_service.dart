import 'package:BabyShopHub/models/cart_item_model.dart';
import 'package:BabyShopHub/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

// class OrderService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<bool> hasUserPurchasedProduct(String userId, String productId) async {
//     try {
//       QuerySnapshot orderSnapshot = await _firestore
//           .collection('orders')
//           .where('userId', isEqualTo: userId)
//           .where('productIds', arrayContains: productId)
//           .get();

//       return orderSnapshot.docs.isNotEmpty;
//     } catch (e) {
//       Logger().e('Error checking if user purchased product: $e');
//       return false;
//     }
//   }
// }


class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    await _firestore.collection('orders').add(order.toMap());
  }

  Future<void> updateProductStock(List<CartItem> items) async {
    final batch = _firestore.batch();

    for (var item in items) {
      final productRef =
          _firestore.collection('products').doc(item.product.productId);
      batch.update(productRef, {'stock': FieldValue.increment(-item.quantity)});
    }

    await batch.commit();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore
        .collection('orders')
        .doc(orderId)
        .update({'status': status.toString()});
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }

    Future<bool> hasUserPurchasedProduct(String userId, String productId) async {
    try {
      QuerySnapshot orderSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('productIds', arrayContains: productId)
          .get();

      return orderSnapshot.docs.isNotEmpty;
    } catch (e) {
      Logger().e('Error checking if user purchased product: $e');
      return false;
    }
  }
}