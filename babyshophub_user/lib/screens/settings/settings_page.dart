import 'package:BabyShopHub/providers/user_provider.dart';
import 'package:BabyShopHub/screens/getting_started.dart';
import 'package:BabyShopHub/screens/user/addresses_page.dart';
import 'package:BabyShopHub/screens/user/change_password.dart';
import 'package:BabyShopHub/screens/user/edit_profile_page.dart';
import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:wiredash/wiredash.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // *MARK: Build method
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final user = Provider.of<UserProvider>(context).user;
    final userProvider = Provider.of<UserProvider>(context);

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
                            user?.username?.substring(0, 2).toUpperCase() ??
                                '??',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        user?.username ?? "Unknown",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                    ),
                    Center(
                      child: Text(
                        user?.email ?? 'Unknown',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // MARK: Account
                    // *Account section
                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildRoundedListItem(
                      context: context,
                      handleClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                      icon: UniconsLine.pen,
                      title: 'Edit profile',
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                      context: context,
                      handleClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePassword(),
                          ),
                        );
                      },
                      icon: UniconsLine.lock,
                      title: 'Change password',
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                        context: context,
                        icon: UniconsLine.location_point,
                        title: 'Addresses',
                        trailing: const Icon(Icons.chevron_right),
                        handleClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddressesPage(),
                            ),
                          );
                        }),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                      context: context,
                      icon: UniconsLine.card_atm,
                      title: 'Payment Methods',
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                      context: context,
                      icon: UniconsLine.package,
                      title: 'Orders',
                      trailing: const Icon(Icons.chevron_right),
                    ),

                    const SizedBox(height: 32),

                    // MARK: General
                    // *General section
                    Text(
                      'General',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildRoundedListItem(
                      context: context,
                      icon: UniconsLine.moon,
                      title: 'Dark Theme',
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (bool value) {
                          themeProvider.toggleTheme(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                      context: context,
                      handleClick: () {
                        _showDialog(context);
                      },
                      icon: UniconsLine.info_circle,
                      title: 'About us',
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    const SizedBox(height: 12),
                    _buildRoundedListItem(
                      context: context,
                      handleClick: () {
                        Wiredash.of(context).show(inheritMaterialTheme: true);
                      },
                      // icon: Icons.contact_support,
                      icon: UniconsLine.comment_question,
                      title: 'Help',
                      trailing: const Icon(Icons.chevron_right),
                    ),

                    // *Log out button
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        userProvider.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GettingStarted(),
                          ),
                          (route) => false,
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

  // *MARK: List Item
  Widget _buildRoundedListItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? handleClick,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: handleClick,
      child: Container(
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
