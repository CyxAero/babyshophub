import 'package:babyshophub_admin/models/user_model.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  final UserModel user;

  const UsersPage({super.key, required this.user});

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