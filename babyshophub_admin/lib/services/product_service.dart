import "dart:io";

import 'package:babyshophub_admin/models/category_model.dart';
import 'package:babyshophub_admin/models/product_model.dart';
import 'package:babyshophub_admin/services/review_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class ProductService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> addProduct(ProductModel product) async {
    await _productCollection.add(product.toFirestore());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productCollection
        .doc(product.productId)
        .update(product.toFirestore());
  }

  Future<void> deleteProduct(String productId) async {
    try {
      // Fetch the product document
      DocumentSnapshot productDoc =
          await _productCollection.doc(productId).get();
      if (productDoc.exists) {
        final product = ProductModel.fromFirestore(productDoc);

        // Delete all product images from Firebase Storage
        for (String imageUrl in product.images) {
          try {
            // Extract the image path from the URL
            final imageRef = storage.refFromURL(imageUrl);
            await imageRef.delete();
            Logger().i('Deleted image: $imageUrl');
          } catch (e) {
            Logger().e('Failed to delete image: $e');
          }
        }

        // Delete all related reviews
        final reviewService = ReviewService();
        await reviewService.deleteReviewsForProduct(productId);

        // Delete the product document from Firestore
        await _productCollection.doc(productId).delete();
        Logger().i('Deleted product with ID: $productId');
      } else {
        Logger().w('Product with ID $productId does not exist.');
      }
    } catch (e) {
      Logger().e('Failed to delete product with ID $productId: $e');
      throw e; // Re-throw the exception to be handled by the caller
    }
  }

  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot snapshot = await _productCollection.get();
    return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }

  Future<ProductModel> getProductById(String productId) async {
    DocumentSnapshot doc = await _productCollection.doc(productId).get();
    return ProductModel.fromFirestore(doc);
  }

  Future<String> uploadImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('product_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);

    try {
      await uploadTask;
      return await storageReference.getDownloadURL();
    } catch (e) {
      Logger().e("Image upload error: $e");
      rethrow; // Propagate the error so it can be caught in the calling function
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    QuerySnapshot snapshot = await _categoryCollection.get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _categoryCollection.add(category.toFirestore());
  }

  Future<void> updateProductImages(
      String productId, List<File> newImages) async {
    // Fetch existing product
    DocumentSnapshot doc = await _productCollection.doc(productId).get();
    ProductModel product = ProductModel.fromFirestore(doc);

    // Upload new images and get their URLs
    List<String> newImageUrls = [];
    for (File image in newImages) {
      String imageUrl = await uploadImage(image);
      newImageUrls.add(imageUrl);
    }

    // Update product images in Firestore
    product.images = newImageUrls;
    await _productCollection.doc(productId).update(product.toFirestore());
  }
}