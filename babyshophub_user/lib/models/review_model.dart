import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewId;
  final String userId;
  final String productId;
  final int rating;
  final String comment;
  final Timestamp reviewDate;

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

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewId: map['reviewId'] ?? '',
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      reviewDate: map['reviewDate'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'reviewDate': reviewDate,
    };
  }
}