import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/theme/theme_extension.dart';
import 'package:babyshophub_admin/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  final UserModel user;

  const ProductsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              toolbarHeight: 30,
              expandedHeight: 150.0,
              collapsedHeight: 52,
              flexibleSpace: Padding(
                // TODO: Do you want to use padding or not??
                padding: const EdgeInsets.only(left: 16),
                child: FlexibleSpaceBar(
                  title: Text(
                    'Products',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              // bottom: PreferredSize(
              //   preferredSize: const Size.fromHeight(52),
              //   child: SizedBox(
              //     height: 52,
              //     child: ListView(
              //       scrollDirection: Axis.horizontal,
              //       padding: const EdgeInsets.symmetric(horizontal: 16),
              //       children: [
              //         Container(
              //           decoration: BoxDecoration(
              //             shape: BoxShape.rectangle,
              //             color: Theme.of(context).colorScheme.orange,
              //             borderRadius:
              //                 const BorderRadius.all(Radius.circular(18)),
              //           ),
              //           child: IconButton(
              //             icon: const Icon(Icons.search),
              //             onPressed: () {
              //               // TODO: Implement search functionality
              //             },
              //           ),
              //         ),
              //         const SizedBox(width: 8),
              //         FilterChip(
              //           label: const Text('Food'),
              //           onSelected: (bool selected) {},
              //         ),
              //         const SizedBox(width: 8),
              //         FilterChip(
              //           label: const Text('Clothes'),
              //           onSelected: (bool selected) {},
              //         ),
              //         const SizedBox(width: 8),
              //         FilterChip(
              //           label: const Text('Toys'),
              //           onSelected: (bool selected) {},
              //         ),
              //         const SizedBox(width: 8),
              //         FilterChip(
              //           label: const Text('Furniture'),
              //           onSelected: (bool selected) {},
              //         ),
              //         const SizedBox(width: 8),
              //         FilterChip(
              //           label: const Text('Gear'),
              //           onSelected: (bool selected) {},
              //         ),
              //         // Add more filter chips as needed
              //       ],
              //     ),
              //   ),
              // ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 60.0,
                maxHeight: 60.0,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Theme.of(context).colorScheme.orange,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                // TODO: Implement search functionality
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip('Food'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Clothes'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Furniture'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Toys'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Electronics'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Shoes'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Kitchen'),
                          // Add more filter chips as needed
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 16,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ProductCard(
                      name: 'Product ${index + 1}',
                      price: '\$${(index + 1) * 100}',
                      imageUrl: 'assets/images/watch.jpeg',
                    );
                  },
                  childCount: 10, // Replace with actual product count
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement bottom sheet for adding new product
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (bool selected) {},
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.blue[100],
      labelStyle: const TextStyle(fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
