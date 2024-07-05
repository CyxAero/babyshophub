import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String reviewId;
  String userId;
  String productId;
  int rating;
  String comment;
  Timestamp reviewDate;

  ReviewModel({
    required this.reviewId,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.reviewDate,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      reviewId: doc.id,
      userId: data['userId'] ?? '',
      productId: data['productId'] ?? '',
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
      reviewDate: data['reviewDate'] ?? Timestamp.now(),
    );
  }
}