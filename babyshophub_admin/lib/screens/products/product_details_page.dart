import 'package:babyshophub_admin/models/product_model.dart';
import 'package:babyshophub_admin/widgets/basic_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BasicAppBar(
        height: 60,
        title: product.name,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display product images
            if (product.images.isNotEmpty)
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: product.images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(child: Text('Failed to load image')),
                    );
                  },
                ),
              ),
            // Display product details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '\$${product.price}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(product.description),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.remove),
            ),
            const Text('1'), // This should be dynamic
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
