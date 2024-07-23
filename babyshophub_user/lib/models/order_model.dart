import 'package:BabyShopHub/models/cart_item_model.dart';
import 'package:BabyShopHub/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class OrderModel {
//   String orderId;
//   String userId;
//   List<OrderItem> items;
//   double totalPrice;
//   String orderStatus;
//   Timestamp orderDate;

//   OrderModel({
//     required this.orderId,
//     required this.userId,
//     required this.items,
//     required this.totalPrice,
//     required this.orderStatus,
//     required this.orderDate,
//   });

//   factory OrderModel.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data() as Map<String, dynamic>;
//     return OrderModel(
//       orderId: doc.id,
//       userId: data['userId'] ?? '',
//       items: (data['items'] as List)
//           .map((item) => OrderItem.fromMap(item))
//           .toList(),
//       totalPrice: data['totalPrice'] ?? 0.0,
//       orderStatus: data['orderStatus'] ?? '',
//       orderDate: data['orderDate'] ?? Timestamp.now(),
//     );
//   }
// }

// class OrderItem {
//   String productId;
//   int quantity;

//   OrderItem({
//     required this.productId,
//     required this.quantity,
//   });

//   factory OrderItem.fromMap(Map<String, dynamic> data) {
//     return OrderItem(
//       productId: data['productId'] ?? '',
//       quantity: data['quantity'] ?? 0,
//     );
//   }
// }

enum OrderStatus { processing, shipped, completed }

class OrderModel {
  final String? id;
  final String userId;
  final Address shippingAddress;
  final List<CartItem> items;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.shippingAddress,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'userId': userId,
  //     'items': items.map((item) => item.toMap()).toList(),
  //     'total': total,
  //     'status': status.toString(),
  //     'createdAt': Timestamp.fromDate(createdAt),
  //   };
  // }

  // factory OrderModel.fromFirestore(DocumentSnapshot doc) {
  //   Map data = doc.data() as Map<String, dynamic>;
  //   return OrderModel(
  //     id: doc.id,
  //     userId: data['userId'],
  //     items: (data['items'] as List)
  //         .map((item) => CartItem.fromMap(item))
  //         .toList(),
  //     total: data['total'],
  //     status:
  //         OrderStatus.values.firstWhere((e) => e.toString() == data['status']),
  //     createdAt: (data['createdAt'] as Timestamp).toDate(),
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'shippingAddress': shippingAddress,
      'total': total,
      'status': status.toString(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'],
      shippingAddress: data['shippingAddress'],
      items: (data['items'] as List)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      total: data['total'],
      status:
          OrderStatus.values.firstWhere((e) => e.toString() == data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
