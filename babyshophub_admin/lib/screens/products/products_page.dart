import 'package:babyshophub_admin/models/product_model.dart';
import 'package:babyshophub_admin/screens/products/add_product_sheet.dart';
import 'package:babyshophub_admin/screens/products/product_details_page.dart';
import 'package:babyshophub_admin/services/product_service.dart';
import 'package:babyshophub_admin/widgets/custom_snackbar.dart';
import 'package:babyshophub_admin/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<ProductModel>> _productsFuture;
  final List<String> _selectedProductIds = [];
  final GlobalKey<_ProductsPageState> widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    final productService = ProductService();
    setState(() {
      _productsFuture = productService.getProducts();
    });
  }

  Future<void> _refreshProducts() async {
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProducts,
          child: FutureBuilder<List<ProductModel>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'Failed to load products',
                  style: Theme.of(context).textTheme.displaySmall,
                ));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(context);
              } else {
                final products = snapshot.data!;
                return _buildProductGrid(context, products);
              }
            },
          ),
        ),
      ),
      floatingActionButton: _selectedProductIds.isEmpty
          ? FloatingActionButton(
              onPressed: () => _showAddProductBottomSheet(context),
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: _confirmDelete,
              backgroundColor: Theme.of(context).colorScheme.error,
              child: const Icon(Icons.delete),
            ),
    );
  }

  // MARK: Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Oops, no products here yet.',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Add a new product.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  // MARK: Build product grid
  Widget _buildProductGrid(BuildContext context, List<ProductModel> products) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/toys.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: Text(
                      'Your Products',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ],
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
                final product = products[index];
                final isSelected =
                    _selectedProductIds.contains(product.productId);
                return GestureDetector(
                  onTap: () {
                    if (_selectedProductIds.isNotEmpty) {
                      _toggleSelection(product.productId);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            product: product,
                          ),
                        ),
                      );
                    }
                  },
                  onLongPress: () {
                    _toggleSelection(product.productId);
                  },
                  child: Stack(
                    children: [
                      ProductCard(
                        name: product.name,
                        price: '\$${product.price.toStringAsFixed(2)}',
                        imageUrl: product.images.isNotEmpty
                            ? product.images[0]
                            : 'assets/images/placeholder.png',
                      ),
                      if (isSelected)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }

  // MARK: Product Bottom Sheet
  void _showAddProductBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      showDragHandle: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: ProductBottomSheet(
          onProductAdded: _fetchProducts,
        ),
      ),
    );
  }

  // MARK: Toggle Selection
  void _toggleSelection(String productId) {
    setState(() {
      if (_selectedProductIds.contains(productId)) {
        _selectedProductIds.remove(productId);
      } else {
        _selectedProductIds.add(productId);
      }
    });
  }

  // MARK: Confirm Delete
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Products',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete the selected products?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteSelectedProducts();
                Navigator.of(context).pop();
              },
              child: Text('Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        );
      },
    );
  }

  // MARK: Delete Products
  Future<void> _deleteSelectedProducts() async {
    final productService = ProductService();

    try {
      for (String productId in _selectedProductIds) {
        await productService.deleteProduct(productId).then((result) => {
              CustomSnackBar.showCustomSnackbar(
                context,
                'Selected products deleted successfully!',
                false,
              )
            });
      }
      _fetchProducts();
    } catch (e) {
      final context = widgetKey.currentContext;
      if (context != null && context.mounted) {
        CustomSnackBar.showCustomSnackbar(
          context,
          'Failed to delete selected products. Please try again.',
          true,
        );
      }
    }
    setState(() {
      _selectedProductIds.clear();
    });
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
