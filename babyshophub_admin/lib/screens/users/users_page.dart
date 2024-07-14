import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {

  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text(
          "Your Customers",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
