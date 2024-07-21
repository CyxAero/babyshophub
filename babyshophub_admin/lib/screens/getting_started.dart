import 'package:babyshophub_admin/screens/auth/login_screen.dart';
import 'package:babyshophub_admin/screens/auth/register_screen.dart';
import 'package:babyshophub_admin/theme/theme_extension.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ExtendedImage.asset(
            'assets/images/baby.jpg',
            fit: BoxFit.cover,
            enableMemoryCache: true,
          ),
          // Other widgets on top of the background image here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'BabyShopHub',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 40,
                              ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Setup your store today",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.white1,
                          ),
                    ),
                    const SizedBox(height: 12),
                    // * Register button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: Theme.of(context).colorScheme.white1,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ));
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    
                    // *Log in button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor:
                              Theme.of(context).colorScheme.cadetGrey,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
