import 'package:babyshophub_admin/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';

class RatingsAndReviewsPage extends StatelessWidget {
  final String productId;

  const RatingsAndReviewsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        height: 80,
        title: "Ratings & Reviews",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 40,
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                "Ratings & Reviews",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            )
          ],
        ),
      ),
    );
  }
}
