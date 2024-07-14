import 'package:babyshophub_admin/providers/user_provider.dart';
import 'package:babyshophub_admin/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {

  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(title: "Your Dashboard", height: 80),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dashboard",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  "Hello, ${user?.username ?? 'User'}!",
                  style: Theme.of(context).textTheme.displaySmall,
                ), // Accessing username
              ],
            ),
          ),
        ),
      ),
    );
  }
}
