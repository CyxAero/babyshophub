import 'package:BabyShopHub/models/product_model.dart';
import 'package:BabyShopHub/models/review_model.dart';
import 'package:BabyShopHub/screens/shop/ratings_and_reviews_page.dart';
import 'package:BabyShopHub/services/review_service.dart';
import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:unicons/unicons.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final PageController _pageController = PageController();
  final ReviewService _reviewService = ReviewService();
  int amount = 1;
  List<ReviewModel> _reviews = [];
  bool _isLoadingReviews = true;
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReviewsAndRating();
  }

  Future<void> _loadReviewsAndRating() async {
    setState(() => _isLoadingReviews = true);

    final reviews = await _reviewService.getReviewsForProduct(
      widget.product.productId,
      pageSize: 3,
    );

    final averageRating = await _reviewService.getAverageRatingForProduct(
      widget.product.productId,
    );

    setState(() {
      _reviews = reviews;
      _averageRating = averageRating;
      _isLoadingReviews = false;
    });
  }


  // *MARK: Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const BasicAppBar(
        height: 50,
        title: "Product Details",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // *Image carousel
            _buildImageCarousel(widget.product.images),

            // *Details Body
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // *Title and Rating
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    height: 1,
                                  ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  _averageRating.toStringAsFixed(1),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                Text(
                                  ' (${widget.product.reviews.length} ratings)',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // *Price
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // *Product Description
                  Text(
                    widget.product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 24),

                  // *Reviews Section
                  _buildReviewsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  //* MARK: IMAGE CAROUSEL
  Widget _buildImageCarousel(List<String> images) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.antiAlias,
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 16,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: JumpingDotEffect(
                  dotColor: Colors.white54,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotHeight: 8,
                  dotWidth: 8,
                  jumpScale: 1.5,
                  verticalOffset: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // *MARK: REVIEWS SECTION
  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingsAndReviewsPage(
                      productId: widget.product.productId,
                    ),
                  ),
                );
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isLoadingReviews)
          const CircularProgressIndicator()
        else if (_reviews.isEmpty)
          const Text('No reviews yet')
        else
          Column(
            children:
                _reviews.map((review) => _buildReviewItem(review)).toList(),
          ),
      ],
    );
  }

  // *MARK: REVIEW ITEM
  Widget _buildReviewItem(ReviewModel review) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  review.rating.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              review.comment,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  // *MARK: BOTTOM BUTTONS
  Widget _buildBottomButtons() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            width: 1.5,
          ),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Row(
            children: [
              // *Minus button
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.red,
                ),
                onPressed: _decreaseAmount,
                icon: const Icon(UniconsLine.minus),
              ),

              const SizedBox(width: 4),

              // *Quantity input
              SizedBox(
                width: 32,
                child: Text(
                  amount.toString(),
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(width: 4),

              // *Add button
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.beige,
                ),
                color: Theme.of(context).colorScheme.black2,
                onPressed: _increaseAmount,
                icon: const Icon(UniconsLine.plus),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // *Add to Cart Button
          Expanded(
            child: ElevatedButton(
              onPressed: _handleAddToCart,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Text('Add to cart'),
            ),
          ),
        ],
      ),
    );
  }

  // *MARK: Handle Add to cart
  void _handleAddToCart() {}

  void _decreaseAmount() {
    setState(() {
      if (amount > 1) {
        amount--;
      }
    });
  }

  void _increaseAmount() {
    setState(() {
      if (amount < widget.product.stock) {
        amount++;
      }
    });
  }
}
