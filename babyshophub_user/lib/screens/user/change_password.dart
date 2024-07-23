import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController txtCurrentPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const BasicAppBar(height: 60, title: "Change Password"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: txtCurrentPassword,
                obscureText: showCurrentPassword,
                decoration: InputDecoration(
                  hintText: "*********",
                  labelText: "Current Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surface.withAlpha(200),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: txtNewPassword,
                obscureText: showNewPassword,
                decoration: InputDecoration(
                  hintText: "*********",
                  labelText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surface.withAlpha(200),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: txtConfirmPassword,
                obscureText: showConfirmPassword,
                decoration: InputDecoration(
                  hintText: "*********",
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surface.withAlpha(200),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(24),
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Change',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.black2,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
