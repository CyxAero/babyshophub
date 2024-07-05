import 'package:babyshophub_user/models/user_model.dart';
import 'package:babyshophub_user/screens/dashboard/dashboard_page.dart';
import 'package:babyshophub_user/screens/dashboard/settings_page.dart';
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
      Products(user: widget.user),
      Cart(user: widget.user),
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
          onDestinationSelected: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_customize_rounded),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_rounded),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_rounded),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class Cart extends StatelessWidget {
  final UserModel user;

  const Cart({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Your Cart",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}

class Products extends StatelessWidget {
  final UserModel user;

  const Products({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Products",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}