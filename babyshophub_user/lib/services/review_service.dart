import 'package:BabyShopHub/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final CollectionReference _reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

  final Map<String, List<ReviewModel>> _cachedReviews = {};
  final Map<String, double> _cachedAverageRatings = {};

  Future<List<ReviewModel>> getReviewsForProduct(String productId,
      {int pageSize = 10, DocumentSnapshot? lastDocument}) async {
    if (_cachedReviews.containsKey(productId) && lastDocument == null) {
      return _cachedReviews[productId]!;
    }

    Query query = _reviewsCollection
        .where('productId', isEqualTo: productId)
        .orderBy('reviewDate', descending: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot snapshot = await query.get();
    List<ReviewModel> reviews =
        snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();

    if (lastDocument == null) {
      _cachedReviews[productId] = reviews;
    } else {
      _cachedReviews[productId]?.addAll(reviews);
    }

    return reviews;
  }

  // Future<void> addReview(ReviewModel review) async {
  //   await _reviewsCollection.add(review.toMap());
  // }

  Future<void> addReview(ReviewModel review) async {
    await _reviewsCollection.add(review.toMap());
    // Clear the cache for this product
    _cachedReviews.remove(review.productId);
    _cachedAverageRatings.remove(review.productId);
  }

  // Method to clear all cached data
  void clearCache() {
    _cachedReviews.clear();
    _cachedAverageRatings.clear();
  }

  Future<void> updateReview(ReviewModel review) async {
    await _reviewsCollection.doc(review.reviewId).update(review.toMap());
  }

  Future<void> deleteReview(String reviewId) async {
    await _reviewsCollection.doc(reviewId).delete();
  }

  Future<void> deleteReviewsForProduct(String productId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    QuerySnapshot snapshot =
        await _reviewsCollection.where('productId', isEqualTo: productId).get();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<double> getAverageRatingForProduct(String productId) async {
    if (_cachedAverageRatings.containsKey(productId)) {
      return _cachedAverageRatings[productId]!;
    }

    QuerySnapshot snapshot =
        await _reviewsCollection.where('productId', isEqualTo: productId).get();

    if (snapshot.docs.isEmpty) return 0.0;

    double totalRating = snapshot.docs.fold(
      0.0,
      (sum, doc) => sum + (doc.data() as Map<String, dynamic>)['rating'],
    );
    double averageRating = totalRating / snapshot.docs.length;

    _cachedAverageRatings[productId] = averageRating;
    return averageRating;
  }
}