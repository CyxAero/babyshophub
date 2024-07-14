import 'package:babyshophub_admin/providers/user_provider.dart';
import 'package:babyshophub_admin/screens/dashboard/main_app.dart';
import 'package:babyshophub_admin/screens/getting_started.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.user != null) {
          return const MainApp();
        } else {
          return FutureBuilder(
            future: userProvider.initUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else {
                if (userProvider.user != null) {
                  return const MainApp();
                } else {
                  return const GettingStarted();
                }
              }
            },
          );
        }
      },
    );
  }
}