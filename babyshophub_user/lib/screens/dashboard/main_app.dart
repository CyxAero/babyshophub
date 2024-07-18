import 'package:BabyShopHub/screens/saved/saved_products_page.dart';
import 'package:BabyShopHub/screens/settings/settings_page.dart';
import 'package:BabyShopHub/screens/shop/search_page.dart';
import 'package:BabyShopHub/screens/shop/shop_page.dart';
import 'package:flutter/material.dart';

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
      const SearchPage(),
      const SavedProductsPage(),
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
        child: NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: Theme.of(context).colorScheme.primary,
          height: 100,
          selectedIndex: _currentPage,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: const Duration(seconds: 1),
          onDestinationSelected: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag_rounded),
              label: 'Shop',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search_rounded),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline_rounded),
              selectedIcon: Icon(Icons.bookmark_rounded),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
