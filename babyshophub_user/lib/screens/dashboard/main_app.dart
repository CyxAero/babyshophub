import 'package:BabyShopHub/models/user_model.dart';
import 'package:BabyShopHub/screens/cart/cart_page.dart';
import 'package:BabyShopHub/screens/dashboard/dashboard_page.dart';
import 'package:BabyShopHub/screens/saved/saved_products_page.dart';
import 'package:BabyShopHub/screens/settings/settings_page.dart';
import 'package:BabyShopHub/screens/shop/shop_page.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  final UserModel user;

  const MainApp({super.key, required this.user});

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
      DashboardPage(user: widget.user),
      ShopPage(user: widget.user),
      CartPage(user: widget.user),
      SavedProductsPage(user: widget.user),
      SettingsPage(user: widget.user),
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
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag_rounded),
              label: 'Shop',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(Icons.shopping_cart_rounded),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Icons.saved_search_outlined),
              selectedIcon: Icon(Icons.saved_search_rounded),
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