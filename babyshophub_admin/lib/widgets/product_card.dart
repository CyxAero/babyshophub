import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageUrl.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Text('Failed to load image')),
                )
              : Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          // *Favourite button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {
                // TODO: Implement wishlist functionality
              },
            ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
