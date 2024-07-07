import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String? title;

  const BasicAppBar({super.key, required this.height, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.chevron_left_rounded, size: 32),
        ),
        onPressed: () {
          Navigator.of(context).pop(); // Handle back navigation
        },
      ),
      title: Text(
        title!,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
        maxLines: 2,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
