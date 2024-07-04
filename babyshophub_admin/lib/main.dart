import 'dart:io';

import 'package:babyshophub_admin/firebase_options.dart';
import 'package:babyshophub_admin/screens/auth/auth_check.dart';
import 'package:babyshophub_admin/services/auth_service.dart';
import 'package:babyshophub_admin/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // *Make status bar transparent
    // statusBarColor: Colors.transparent,

    // *Make navigation bar transparent
    systemNavigationBarColor: Colors.transparent,

    // *Control icon brightness
    // systemNavigationBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // *Loading .env file
  await dotenv.load(fileName: '.env');

  // ?Connecting to firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BabyShopHub Admin',
            theme: themeProvider.themeData,
            home: const AuthCheck(),
          );
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return Builder(
//       builder: (context) {
//         final brightness = MediaQuery.of(context).platformBrightness;
//         const theme = BabyShopHubTheme();

//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'BabyShopHub Admin',
//           theme: theme.lightTheme,
//           darkTheme: theme.darkTheme,
//           themeMode:
//               brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
//           home: const GettingStarted(),
//         );

//       },
//     );
//   }
// }


// DONE: Connect to firebase backend
// TODO: Create main app and connect to firebase backend
// TODO: Initialize git