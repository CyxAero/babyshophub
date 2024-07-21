import 'package:babyshophub_admin/screens/dashboard/dashboard_page.dart';
import 'package:babyshophub_admin/providers/user_provider.dart';
import 'package:babyshophub_admin/screens/orders/orders_page.dart';
import 'package:babyshophub_admin/screens/products/products_page.dart';
import 'package:babyshophub_admin/screens/settings/settings_page.dart';
import 'package:babyshophub_admin/screens/users/users_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentPage = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize pages with the other pages that don't require user
    pages = [
      DashboardPage(),
      const ProductsPage(),
      const OrdersPage(),
      const UsersPage(),
      SettingsPage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    // Only add SettingsPage if user is not null
    if (user != null && pages.length == 4) {
      pages.add(SettingsPage(user: user));
    }

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
          height: 80,
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
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_outlined),
              selectedIcon: Icon(Icons.receipt_rounded),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outlined),
              selectedIcon: Icon(Icons.people_rounded),
              label: 'Users',
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
