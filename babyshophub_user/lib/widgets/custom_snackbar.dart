import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showCustomSnackbar(
    BuildContext context,
    String message,
    bool isError,
  ) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isError
        ? Theme.of(context).colorScheme.error
        : isDarkTheme
            ? Theme.of(context).colorScheme.pastelBlue
            : Theme.of(context).colorScheme.black1;

    final snackBar = SnackBar(
      elevation: 0,
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDarkTheme
                  ? Theme.of(context).colorScheme.black1
                  : Theme.of(context).colorScheme.white1,
            ),
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      dismissDirection: DismissDirection.horizontal, // Dismiss on swipe
      duration: const Duration(
        milliseconds: 4000,
      ), // Dismiss automatically after 4 seconds
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
