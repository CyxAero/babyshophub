import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/widgets/custom_appbar.dart';
import 'package:BabyShopHub/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:BabyShopHub/providers/wishlist_provider.dart';
import 'package:BabyShopHub/screens/shop/product_card.dart';
import 'package:BabyShopHub/screens/shop/product_details_page.dart';

class SavedProductsPage extends StatelessWidget {
  const SavedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(title: "Your saved products", height: 80),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          if (wishlistProvider.savedProducts.isEmpty) {
            return Center(
              child: Text(
                "You haven't saved any products yet.",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: wishlistProvider.savedProducts.length,
            itemBuilder: (context, index) {
              final product = wishlistProvider.savedProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        product: product,
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    ProductCard(product: product, isInShop: false),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Theme.of(context).colorScheme.green,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: 'Remove Product',
                                content:
                                    'Are you sure you want to remove this product from your saved list?',
                                cancelText: 'Cancel',
                                confirmText: 'Remove',
                                onConfirm: () {
                                  wishlistProvider.toggleSavedProduct(product);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
