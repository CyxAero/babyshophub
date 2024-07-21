import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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