
import 'package:babyshophub_admin/screens/settings/update_profile_screen.dart';
import 'package:babyshophub_admin/theme/theme_extension.dart';
import 'package:babyshophub_admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;


  const DashboardAppBar({super.key, required this.title, required this.height});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
        maxLines: 2,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () {
              // Handle button tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  UpdateProfileScreen(user: user,),
                ),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.lightGreen,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    user?.username?.substring(0, 2).toUpperCase() ?? '??',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
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
  Size get preferredSize => Size.fromHeight(height);
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
