import 'package:BabyShopHub/models/user_model.dart';
import 'package:flutter/material.dart';

class SavedProductsPage extends StatelessWidget {
  final UserModel user;

  const SavedProductsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text(
          "Your Saved Products",
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
