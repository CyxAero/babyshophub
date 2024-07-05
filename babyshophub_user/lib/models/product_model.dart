import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String productId;
  String name;
  String description;
  double price;
  List<String> images;
  String category;
  int stock;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.stock,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? 0.0,
      images: List<String>.from(data['images'] ?? []),
      category: data['category'] ?? '',
      stock: data['stock'] ?? 0,
    );
  }
}