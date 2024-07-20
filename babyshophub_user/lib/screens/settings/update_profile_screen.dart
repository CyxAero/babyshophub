import 'package:BabyShopHub/screens/Payment/payment.dart';
import 'package:BabyShopHub/screens/address/addresses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:BabyShopHub/models/user_model.dart';
import 'package:BabyShopHub/widgets/title_appbar.dart';
import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatelessWidget {
  final UserModel? user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
   final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const TitleAppbar(title: "Edit Profile"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // User profile section with rounded square avatar and edit icon
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.lightGreen,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        user?.username?.substring(0, 2).toUpperCase() ?? '??',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.black, // Background color
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          // Handle edit action
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Username",
                        hintText: user?.username ?? 'User',
                        prefixIcon: const Icon(Icons.person),
                        fillColor: const Color(0xFFF2F7EB),
                        filled: true,
                        labelStyle: const TextStyle(color: Colors.black),
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIconColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: Color(0xFFF2F7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: Color(0xFFF2F7EB)),
                        ),
                        contentPadding: const EdgeInsets.all(22.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black), // Text color
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: user?.email ?? 'user@example.com',
                        prefixIcon: const Icon(Icons.email),
                        fillColor: const Color(0xFFF2F7EB),
                        filled: true,
                        labelStyle: const TextStyle(color: Colors.black),
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIconColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: Color(0xFFF2F7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: Color(0xFFF2F7EB)),
                        ),
                        contentPadding: const EdgeInsets.all(22.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black), // Text color
                    ),
                    const SizedBox(height: 16),
                    RoundedListItem(
                        icon: Icons.location_on,
                        title: 'Shipping Addresses',
                        trailing: const Icon(Icons.chevron_right),
                        isDarkMode: isDarkMode,
                         onTap: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const UserAddressScreen(),
                          ),
                        );
                        }
                        ),
                    const SizedBox(height: 16),
                   RoundedListItem(
                        icon: Icons.account_balance_wallet,
                        title: 'Payment Methods',
                        trailing: const Icon(Icons.chevron_right),
                        isDarkMode: isDarkMode,
                         onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const Payment(),
                          ),
                        );
                        }
                        ),
                    const SizedBox(height: 48),
                    // *submit button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(22),
                        elevation: 0,
                        backgroundColor: Theme.of(context).colorScheme.orange,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Save',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.black2,
                                ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          elevation: 0,
                          foregroundColor: Colors.red,
                          shape: const StadiumBorder(),
                          side: BorderSide.none),
                      child: const Text("Delete Profile"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final bool isDarkMode;
  final VoidCallback? onTap;
  const RoundedListItem({super.key, required this.icon, required this.title, required this.trailing, required this.isDarkMode, this.onTap});

  @override
  Widget build(BuildContext context) {
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
          onTap: onTap,
        ),
      ),
    );
  }
}
