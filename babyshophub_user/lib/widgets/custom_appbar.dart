import 'package:BabyShopHub/models/user_model.dart';
import 'package:BabyShopHub/screens/cart/cart_page.dart';
import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/widgets/cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
        maxLines: 2,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(UniconsLine.search),
        )
      ],
      backgroundColor: Colors.transparent,
      toolbarHeight: height,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Size get preferredSize => const Size.fromHeight(100);
}
