import 'package:BabyShopHub/providers/cart_provider.dart';
import 'package:BabyShopHub/screens/cart/cart_page.dart';
import 'package:BabyShopHub/screens/saved/saved_products_page.dart';
import 'package:BabyShopHub/screens/settings/settings_page.dart';
import 'package:BabyShopHub/screens/shop/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:unicons/unicons.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentPage = 0;

  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages.addAll([
      const ShopPage(),
      const SavedProductsPage(),
      const CartPage(),
      const SettingsPage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentPage],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              width: 1.5,
            ),
          ),
        ),
        child: Consumer<CartProvider>(
          builder: (context, cart, child) => NavigationBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: Theme.of(context).colorScheme.primary,
            height: 80,
            selectedIndex: _currentPage,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(seconds: 1),
            onDestinationSelected: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(UniconsLine.shopping_bag),
                label: 'Shop',
              ),
              const NavigationDestination(
                icon: Icon(UniconsLine.bookmark),
                label: 'Saved',
              ),
              NavigationDestination(
                icon: badges.Badge(
                  showBadge: cart.itemCount > 0,
                  badgeContent: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: const Icon(UniconsLine.shopping_cart),
                ),
                label: 'Cart',
              ),
              const NavigationDestination(
                icon: Icon(UniconsLine.setting),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
