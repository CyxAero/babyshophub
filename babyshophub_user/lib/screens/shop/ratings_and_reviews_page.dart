import 'package:BabyShopHub/models/review_model.dart';
import 'package:BabyShopHub/models/user_model.dart';
import 'package:BabyShopHub/providers/user_provider.dart';
import 'package:BabyShopHub/services/order_service.dart';
import 'package:BabyShopHub/services/review_service.dart';
import 'package:BabyShopHub/services/user_service.dart';
import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RatingsAndReviewsPage extends StatefulWidget {
  final String productId;

  const RatingsAndReviewsPage({super.key, required this.productId});

  @override
  State<RatingsAndReviewsPage> createState() => _RatingsAndReviewsPageState();
}

class _RatingsAndReviewsPageState extends State<RatingsAndReviewsPage> {
  late UserProvider _userProvider;
  final ReviewService _reviewService = ReviewService();
  final OrderService _orderService = OrderService();
  final UserService _userService = UserService();

  List<ReviewModel> _reviews = [];
  bool _isLoading = true;
  bool _canAddReview = false;
  DocumentSnapshot? _lastDocument;
  bool _isLoadingMore = false;
  double _averageRating = 0.0;
  Map<int, int> _ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.wait([
        _loadReviews(),
        _loadAverageRating(),
        _checkIfUserCanReview(),
      ]);
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _errorMessage = 'Error loading reviews. Please try again later.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadReviews() async {
    final reviews = await _reviewService.getReviewsForProduct(
      widget.productId,
      pageSize: 10,
    );
    setState(() {
      _reviews = reviews;
      if (reviews.isNotEmpty) {
        _lastDocument = reviews.last as DocumentSnapshot<Object?>?;
      }
      _calculateRatingCounts(reviews);
    });
  }

  void _calculateRatingCounts(List<ReviewModel> reviews) {
    _ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var review in reviews) {
      _ratingCounts[review.rating] = (_ratingCounts[review.rating] ?? 0) + 1;
    }
  }

  Future<void> _loadMoreReviews() async {
    if (_isLoadingMore || _lastDocument == null) return;

    setState(() => _isLoadingMore = true);

    try {
      final moreReviews = await _reviewService.getReviewsForProduct(
        widget.productId,
        pageSize: 10,
        lastDocument: _lastDocument,
      );

      setState(() {
        _reviews.addAll(moreReviews);
        if (moreReviews.isNotEmpty) {
          _lastDocument = moreReviews.last as DocumentSnapshot<Object?>?;
        } else {
          _lastDocument = null; // No more reviews to load
        }
        _calculateRatingCounts(_reviews);
      });
    } catch (e) {
      print('Error loading more reviews: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading more reviews. Please try again.'),
          ),
        );
      }
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _loadAverageRating() async {
    _averageRating =
        await _reviewService.getAverageRatingForProduct(widget.productId);
  }

  Future<void> _checkIfUserCanReview() async {
    final user = _userProvider.user;
    if (user == null) {
      _canAddReview = false;
      return;
    }

    String currentUserId = user.userId;
    bool hasPurchased = await _orderService.hasUserPurchasedProduct(
        currentUserId, widget.productId);
    bool hasReviewed = _reviews.any((review) => review.userId == currentUserId);
    _canAddReview = hasPurchased && !hasReviewed;
  }

  Future<void> _addReview() async {
    // Implement the logic to add a new review
    // You can use a dialog or navigate to a new page for review input
    // After adding the review, reload the reviews
    await _loadInitialData();
  }

  // *MARK: Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        height: 80,
        title: "Ratings & Reviews",
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRatingSummary(),
                              const SizedBox(height: 24),
                              Text(
                                'Reviews',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              _buildReviewsList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildBottomBar(),
                  ],
                ),
      // bottomNavigationBar: _buildBottomBar(),
    );
  }

  // *MARK: Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            "No reviews yet",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Be the first to review this product!",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  // *MARK: Rating Summary
  Widget _buildRatingSummary() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[800]!.withOpacity(0.7)
            : const Color(0xFFF2F7EB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average rating',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 20,
                      ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _averageRating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const Icon(Icons.star, color: Colors.amber),
                  ],
                ),
                Opacity(
                  opacity: 0.7,
                  child: Text('${_reviews.length} ratings'),
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: 4,
            color: Theme.of(context).colorScheme.surface,
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: List.generate(5, (index) {
                int starCount = 5 - index;
                int ratingCount = _ratingCounts[starCount] ?? 0;
                double percentage =
                    _reviews.isEmpty ? 0 : ratingCount / _reviews.length;
                return Row(
                  children: [
                    Text('$starCount'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor:
                            isDarkMode ? Colors.grey[300] : Colors.grey[600],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.amber),
                        borderRadius: BorderRadius.circular(100),
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

  // *MARK: Reviews List
  Widget _buildReviewsList() {
    if (_reviews.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reviews.length + 1,
      itemBuilder: (context, index) {
        if (index < _reviews.length) {
          return _buildReviewItem(_reviews[index]);
        } else if (_lastDocument != null) {
          return _isLoadingMore
              ? const Center(child: CircularProgressIndicator())
              : TextButton(
                  onPressed: _loadMoreReviews,
                  child: const Text('Load More'),
                );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  // *MARK: Review Item
  Widget _buildReviewItem(ReviewModel review) {
    return FutureBuilder<UserModel?>(
      future: _userService.getUserById(review.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;
        final username = user?.username ?? 'Unknown User';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Text(username[0].toUpperCase()),
                      ),
                      const SizedBox(width: 8),
                      Text(username),
                    ],
                  ),
                  Row(
                    children: [
                      Text(review.rating.toString()),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(review.comment),
            ],
          ),
        );
      },
    );
  }

  // *MARK: Bottom Bar
  Widget _buildBottomBar() {
    return Column(
      children: [
        Divider(height: 1.5, color: Colors.grey[600]),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canAddReview ? _addReview : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Add Review',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.white1,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
