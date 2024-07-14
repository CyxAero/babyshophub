import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {

  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text(
          "Your Orders",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
