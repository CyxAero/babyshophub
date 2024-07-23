import 'package:babyshophub_admin/providers/user_provider.dart';
import 'package:babyshophub_admin/services/user_service.dart';
import 'package:babyshophub_admin/theme/theme_extension.dart';
import 'package:babyshophub_admin/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final UserService userService = UserService();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const BasicAppBar(height: 60, title: "Edit Profile"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // User profile section with rounded square avatar and edit icon
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.lightGreen,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        user?.username?.substring(0, 2).toUpperCase() ?? '??',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(UniconsLine.user),
                        hintText: user?.username ?? 'User',
                        labelText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surface
                            .withAlpha(200),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black), // Text color
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(UniconsLine.fast_mail),
                        hintText: user?.email ?? 'user@example.com',
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surface
                            .withAlpha(200),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black), // Text color
                    ),
                    const SizedBox(height: 48),
                    // *submit button
                    ElevatedButton(
                      onPressed: () {
                        // Handle save action
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(24),
                        elevation: 0,
                        backgroundColor: Theme.of(context).colorScheme.orange,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Save',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.black2,
                                ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Handle delete action
                        userService.deleteUser(user!.userId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withOpacity(0.1),
                        elevation: 0,
                        foregroundColor: Colors.red,
                        shape: const StadiumBorder(),
                        side: BorderSide.none,
                      ),
                      child: const Text("Delete Profile"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
