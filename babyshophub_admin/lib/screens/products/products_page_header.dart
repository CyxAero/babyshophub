import 'package:flutter/material.dart';

class ProductCategoryHeader extends StatelessWidget {
  final String title;
  final String backgroundImageUrl;

  const ProductCategoryHeader({
    super.key,
    required this.title,
    required this.backgroundImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundImageUrl,
            fit: BoxFit.cover,
          ),
          // *Linear Gradient
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
              ),
            ),
        ],
      ),
    );
  }
}
