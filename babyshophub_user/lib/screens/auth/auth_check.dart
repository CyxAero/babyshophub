import 'package:BabyShopHub/models/user_model.dart';
import 'package:BabyShopHub/screens/dashboard/main_app.dart';
import 'package:BabyShopHub/screens/getting_started.dart';
import 'package:BabyShopHub/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return FutureBuilder<UserModel?>(
      future: authService.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          UserModel user = snapshot.data!;
          return MainApp(user: user); // Pass the user object
        } else {
          return const GettingStarted();
        }
      },
    );
  }
}