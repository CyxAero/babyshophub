import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Dashboard(user: widget.user),
      Orders(user: widget.user),
      Products(user: widget.user),
      Users(user: widget.user),
      Settings(user: widget.user),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "BabyShopHub Admin",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
          maxLines: 2,
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 150,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
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

class Dashboard extends StatelessWidget {
  final UserModel user;

  const Dashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Dashboard",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text("Hello, $user.name!")
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

class Settings extends StatelessWidget {
  final UserModel user;

  const Settings({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Settings",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 28),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
