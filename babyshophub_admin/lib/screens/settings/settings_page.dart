import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/theme/theme_extension.dart';
import 'package:babyshophub_admin/theme/theme_provider.dart';
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
              centerTitle: true,
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
                        title: 'Edit profile',
                        trailing: const Icon(Icons.chevron_right),
                        isDarkMode: isDarkMode),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                      icon: Icons.lock,
                      title: 'Change password',
                      trailing: const Icon(Icons.chevron_right),
                      isDarkMode: isDarkMode,
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
                        title: 'About us',
                        trailing: const Icon(Icons.chevron_right),
                        isDarkMode: isDarkMode),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                        icon: Icons.contact_support,
                        title: 'Contact us',
                        trailing: const Icon(Icons.chevron_right),
                        isDarkMode: isDarkMode),

                    // *Log out button
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {},
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
        ),
      ),
    );
  }
}
