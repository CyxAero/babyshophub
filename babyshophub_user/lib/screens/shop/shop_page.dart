import 'package:BabyShopHub/models/category_model.dart';
import 'package:BabyShopHub/models/product_model.dart';
import 'package:BabyShopHub/screens/shop/product_card.dart';
import 'package:BabyShopHub/screens/shop/product_details_page.dart';
import 'package:BabyShopHub/services/product_service.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final ProductService _productService = ProductService();
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final products = await _productService.getProducts();
    final categories = await _productService.getCategories();
    setState(() {
      _products = products;
      _categories = categories;
    });
  }

  List<ProductModel> get _filteredProducts {
    if (_selectedCategory == null) return _products;
    return _products
        .where((product) => product.categories.contains(_selectedCategory))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Our Products',
                  style: Theme.of(context).textTheme.headlineMedium),
              background: Image.asset(
                'assets/images/shop_banner.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 60.0,
              maxHeight: 60.0,
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: _buildCategoryFilter(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildCategoryChip('All'),
        ..._categories
            .map((category) => _buildCategoryChip(category.name)),
      ],
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = selected ? label : null;
          });
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final product = _filteredProducts[index];
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
            child: ProductCard(
              name: product.name,
              price: '\$${product.price.toStringAsFixed(2)}',
              imageUrl: product.images.isNotEmpty
                  ? product.images[0]
                  : 'assets/images/placeholder.png',
            ),
          );
        },
        childCount: _filteredProducts.length,
      ),
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
