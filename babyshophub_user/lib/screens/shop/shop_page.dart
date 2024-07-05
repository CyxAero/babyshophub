import 'package:BabyShopHub/models/user_model.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  final UserModel user;

  const ShopPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text(
          "The Shop",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
