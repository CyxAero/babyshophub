import 'package:babyshophub_admin/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final CollectionReference _reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

  Future<List<ReviewModel>> getReviewsForProduct(String productId,
      {int? limit}) async {
    Query query = _reviewsCollection
        .where('productId', isEqualTo: productId)
        .orderBy('reviewDate', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
  }

  Future<void> addReview(ReviewModel review) async {
    await _reviewsCollection.add(review.toMap());
  }

  Future<void> updateReview(ReviewModel review) async {
    await _reviewsCollection.doc(review.reviewId).update(review.toMap());
  }

  Future<void> deleteReview(String reviewId) async {
    await _reviewsCollection.doc(reviewId).delete();
  }
}
