import 'package:babyshophub_admin/models/review_model.dart';
import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/services/review_service.dart';
import 'package:babyshophub_admin/services/user_service.dart';
import 'package:babyshophub_admin/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RatingsAndReviewsPage extends StatefulWidget {
  final String productId;

  const RatingsAndReviewsPage({super.key, required this.productId});

  @override
  State<RatingsAndReviewsPage> createState() => _RatingsAndReviewsPageState();
}

class _RatingsAndReviewsPageState extends State<RatingsAndReviewsPage> {

  List<ReviewModel> reviews = [];
  Map<String, UserModel> reviewUsers = {};
  Set<String> selectedReviews = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => isLoading = true);
    final reviewService = Provider.of<ReviewService>(context, listen: false);
    final userService = UserService();
    try {
      reviews = await reviewService.getReviewsForProduct(widget.productId);
      for (var review in reviews) {
        UserModel? user = await userService.getUserById(review.userId);
        if (user != null) {
          reviewUsers[review.userId] = user;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load reviews: $e')),
      );
    }
    setState(() => isLoading = false);
  }

  void _toggleReviewSelection(String reviewId) {
    setState(() {
      if (selectedReviews.contains(reviewId)) {
        selectedReviews.remove(reviewId);
      } else {
        selectedReviews.add(reviewId);
      }
    });
  }

  Future<void> _deleteSelectedReviews() async {
    final reviewService = Provider.of<ReviewService>(context, listen: false);
    try {
      for (String reviewId in selectedReviews) {
        await reviewService.deleteReview(reviewId);
      }
      await _loadReviews();
      selectedReviews.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected reviews deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete reviews: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double averageRating = reviews.isEmpty
        ? 0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Scaffold(
      appBar: const BasicAppBar(
        height: 80,
        title: "Ratings & Reviews",
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildRatingSummary(averageRating),
                Expanded(child: _buildReviewsList()),
              ],
            ),
      bottomNavigationBar: _buildDeleteButton(),
    );
  }

  Widget _buildRatingSummary(double averageRating) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average rating',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.star, color: Colors.amber),
                  ],
                ),
                Text('${reviews.length} ratings'),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: List.generate(5, (index) {
                int starCount = 5 - index;
                int ratingCount =
                    reviews.where((r) => r.rating == starCount).length;
                double percentage =
                    reviews.isEmpty ? 0 : ratingCount / reviews.length;
                return Row(
                  children: [
                    Text('$starCount'),
                    SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        final user = reviewUsers[review.userId];
        return InkWell(
          onLongPress: () => _toggleReviewSelection(review.reviewId),
          child: Container(
            color: selectedReviews.contains(review.reviewId)
                ? Colors.blue.withOpacity(0.1)
                : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: user?.profileImage != null
                    ? NetworkImage(user!.profileImage!)
                    : null,
                child: user?.profileImage == null
                    ? Text(user?.username?[0] ?? '')
                    : null,
              ),
              title: Row(
                children: [
                  Text(user?.username ?? 'Anonymous'),
                  Spacer(),
                  Text('${review.rating}'),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                ],
              ),
              subtitle: Text(review.comment),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeleteButton() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: selectedReviews.isNotEmpty ? _deleteSelectedReviews : null,
          child: Text('Delete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
