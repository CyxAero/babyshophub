import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:BabyShopHub/providers/wishlist_provider.dart';
import 'package:BabyShopHub/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  final bool isInShop;

  const ProductCard({
    super.key,
    required this.product,
    required this.isInShop,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        bool isSaved = wishlistProvider.isProductSaved(product);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              product.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.images[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(child: Text('Failed to load image')),
                    )
                  : Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
              // *Favourite icon
              if (isInShop)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved
                          ? Theme.of(context).colorScheme.green
                          : Theme.of(context).colorScheme.white1,
                    ),
                    onPressed: () {
                      wishlistProvider.toggleSavedProduct(product);
                    },
                  ),
                ),
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
                        product.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.white1),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.white2,
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
      },
    );
  }
}
