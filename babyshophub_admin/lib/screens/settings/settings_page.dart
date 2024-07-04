import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/theme/theme_provider.dart';
import 'package:babyshophub_admin/widgets/heading_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final UserModel user;

  const SettingsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: "Settings", height: 150),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              Card.filled(
                child: Row(
                  children: [
                    // User's Icon/Profile Picture
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 20),
                    // User's name/username...email?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "<NAME>",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          "<EMAIL>",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Card.filled(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dark Mode",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: isDarkMode,
                          onChanged: (bool value) {
                            themeProvider.toggleTheme(isDarkMode);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Card.filled(
                        child: Text(
                          "Some setting",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card.filled(
                        child: Text(
                          "Some setting",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
