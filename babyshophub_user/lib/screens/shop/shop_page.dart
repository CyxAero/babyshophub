import 'package:BabyShopHub/models/category_model.dart';
import 'package:BabyShopHub/models/product_model.dart';
import 'package:BabyShopHub/screens/shop/product_card.dart';
import 'package:BabyShopHub/screens/shop/product_details_page.dart';
import 'package:BabyShopHub/screens/shop/search_page.dart';
import 'package:BabyShopHub/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

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

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final products = await _productService.getProducts();
    final categories = await _productService.getCategories();

    setState(() {
      _products = products;
      _categories = categories;
      _selectedCategory = 'All';
      _isLoading = false;
    });
  }

  List<ProductModel> get _filteredProducts {
    if (_selectedCategory == 'All' || _selectedCategory == null) {
      return _products;
    }
    return _products
        .where((product) => product.categories.contains(_selectedCategory))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchPage(),
            ),
          );
        },
        child: const Icon(
          UniconsLine.search,
          size: 32,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Our Products',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
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
          SliverToBoxAdapter(
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          if (!_isLoading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              sliver: _buildProductGrid(),
            ),
          // SliverPadding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          //   sliver: _buildProductGrid(),
          // ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return ListView(
      padding: const EdgeInsets.only(left: 16),
      scrollDirection: Axis.horizontal,
      children: [
        _buildCategoryChip('All'),
        ..._categories.map((category) => _buildCategoryChip(category.name)),
      ],
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = selected ? label : 'All';
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Rounded corners
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
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
            child: ProductCard(product: product, isInShop: true),
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
