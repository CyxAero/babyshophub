import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/screens/dashboard/dashboard_page.dart';
import 'package:babyshophub_admin/screens/settings/settings_page.dart';
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
      Orders(user: widget.user),
      Products(user: widget.user),
      Users(user: widget.user),
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
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_rounded),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_alt_rounded),
              label: 'Users',
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

class Orders extends StatelessWidget {
  final UserModel user;

  const Orders({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Orders",
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

class Users extends StatelessWidget {
  final UserModel user;

  const Users({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Users",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}