import 'package:babyshophub_admin/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String productId;
  String name;
  String description;
  double price;
  List<String> images;
  List<String> categories;
  int stock;
  List<ReviewModel> reviews;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.categories,
    required this.stock,
    this.reviews = const [],
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      stock: data['stock'] ?? 0,
      reviews: (data['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'categories': categories,
      'stock': stock,
      'reviews': reviews.map((e) => e.toMap()).toList(),
    };
  }
}