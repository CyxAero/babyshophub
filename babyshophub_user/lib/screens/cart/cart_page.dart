import 'package:BabyShopHub/models/user_model.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final UserModel user;

  const CartPage({super.key, required this.user});

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
