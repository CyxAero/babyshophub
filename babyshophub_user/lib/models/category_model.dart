import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String categoryId;
  String name;

  CategoryModel({
    required this.categoryId,
    required this.name,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      categoryId: doc.id,
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
    };
  }
}