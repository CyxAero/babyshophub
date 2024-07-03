import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String orderId;
  String userId;
  List<OrderItem> items;
  double totalPrice;
  String orderStatus;
  Timestamp orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.orderStatus,
    required this.orderDate,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      orderId: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      totalPrice: data['totalPrice'] ?? 0.0,
      orderStatus: data['orderStatus'] ?? '',
      orderDate: data['orderDate'] ?? Timestamp.now(),
    );
  }
}

class OrderItem {
  String productId;
  int quantity;

  OrderItem({
    required this.productId,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }
}