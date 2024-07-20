import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:BabyShopHub/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {

  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
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
