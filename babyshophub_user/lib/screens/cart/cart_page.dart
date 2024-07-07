import 'package:BabyShopHub/models/user_model.dart';
import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final UserModel user;

  const CartPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        height: 100,
        title: "Your Cart",
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text(
          "Nothing here yet",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
