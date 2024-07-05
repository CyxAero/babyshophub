import 'package:babyshophub_user/models/user_model.dart';
import 'package:babyshophub_user/widgets/heading_appbar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final UserModel user;

  const DashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "BabyShopHub Admin", height: 150),
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
                  "Hello, ${user.username ?? 'User'}!",
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