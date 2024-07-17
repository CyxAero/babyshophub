import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/theme/theme_extension.dart';
import 'package:babyshophub_admin/theme/theme_provider.dart';
// import 'package:babyshophub_admin/widgets/app_dialog.dart';
import 'package:wiredash/wiredash.dart';
import 'package:babyshophub_admin/screens/getting_started.dart';
import 'package:babyshophub_admin/screens/settings/update_profile_screen.dart';
import 'package:babyshophub_admin/screens/settings/change_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final UserModel user;

  const SettingsPage({super.key, required this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // * APPBAR
            SliverAppBar(
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              toolbarHeight: 30,
              expandedHeight: 150.0,
              collapsedHeight: 52,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // *BODY OF SETTINGS PAGE
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // User profile section with rounded square avatar
                    Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.lightGreen,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            widget.user.username!.substring(0, 2).toUpperCase(),
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        widget.user.username ?? "Unknown",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.user.email,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // *Account section
                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildRoundedListItem(
                        icon: Icons.edit,
                      title: 'Edit Profile',
                        trailing: const Icon(Icons.chevron_right),
                      isDarkMode: isDarkMode,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateProfileScreen(user: widget.user),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                      icon: Icons.lock,
                      title: 'Change Password',
                      trailing: const Icon(Icons.chevron_right),
                      isDarkMode: isDarkMode,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangePassword(user: widget.user),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // *General section
                    Text(
                      'General',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildRoundedListItem(
                        icon: Icons.dark_mode,
                        title: 'Dark Theme',
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (bool value) {
                            setState(() {
                              isDarkMode = value;
                            });
                            themeProvider.toggleTheme(isDarkMode);
                          },
                        ),
                        isDarkMode: isDarkMode),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                        icon: Icons.info,
                        title: 'About Us',
                        trailing: const Icon(Icons.chevron_right),
                        isDarkMode: isDarkMode,
                        onTap: () {
                          _showDialog(context);
                        }),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                        icon: Icons.contact_support,
                      title: 'Feedback and Support',
                        trailing: const Icon(Icons.chevron_right),
                      isDarkMode: isDarkMode,
                      onTap: () {
                        Wiredash.of(context).show(inheritMaterialTheme: true);
                      },
                    ),

                    // *Log out button
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GettingStarted()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(22),
                        elevation: 0,
                        backgroundColor: Theme.of(context).colorScheme.orange,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Log out',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.black2,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedListItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    required bool isDarkMode,
    VoidCallback? onTap, // Add this parameter
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[800]!.withOpacity(0.7)
            : const Color(0xFFF2F7EB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: trailing,
          onTap: onTap, // Add this line
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 32,
          insetPadding: const EdgeInsets.all(32),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Container(
            padding: const EdgeInsets.only(
              top: 10,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.surface,
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "About Us",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "This product is a demo of an e-commerce baby shop app. It is not certified and is for educational purposes only.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Okay",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
