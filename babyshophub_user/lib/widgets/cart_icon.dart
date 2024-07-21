import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class CartIcon extends StatelessWidget {
  final Color iconColor;
  final VoidCallback onPressed;

  const CartIcon({super.key, required this.iconColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            UniconsLine.shopping_cart,
            color: isDarkMode
                ? Theme.of(context).colorScheme.white1
                : Theme.of(context).colorScheme.black1,
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                "3",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.black1,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
