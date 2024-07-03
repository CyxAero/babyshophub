import 'package:babyshophub_admin/firebase_options.dart';
import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/screens/dashboard/main_app.dart';
import 'package:babyshophub_admin/screens/getting_started.dart';
import 'package:babyshophub_admin/services/auth_service.dart';
import 'package:babyshophub_admin/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      child: Consumer2<AuthService, ThemeProvider>(
        builder: (context, authService, themeProvider, _) {
          return FutureBuilder(
            future: authService.currentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                UserModel user = snapshot.data!;
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'BabyShopHub Admin',
                  theme: themeProvider.themeData,
                  home: MainApp(user: user), // Pass the user object
                );
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'BabyShopHub Admin',
                  theme: themeProvider.themeData,
                  home: const GettingStarted(),
                );
              }
            },
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