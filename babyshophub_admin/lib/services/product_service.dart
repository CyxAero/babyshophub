import "dart:io";

import 'package:babyshophub_admin/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(ProductModel product) async {
    await _productCollection.add(product.toFirestore());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productCollection
        .doc(product.productId)
        .update(product.toFirestore());
  }

  Future<void> deleteProduct(String productId) async {
    await _productCollection.doc(productId).delete();
  }

  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot snapshot = await _productCollection.get();
    return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }

  Future<String> uploadImage(String filePath) async {
    File file = File(filePath);
    String fileName = basename(filePath);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('product_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() {});
    return await storageReference.getDownloadURL();
  }
}