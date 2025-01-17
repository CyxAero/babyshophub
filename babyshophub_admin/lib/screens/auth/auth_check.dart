import 'dart:async';

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
        return FutureBuilder(
          future: userProvider.initUser().timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('User initialization timed out');
            },
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else {
              // Check if the user is initialized
              if (userProvider.user != null) {
                return const MainApp();
              } else {
                return const GettingStarted();
              }
            }
          },
        );
      },
    );
  }
}