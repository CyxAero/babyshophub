import 'package:babyshophub_admin/firebase_options.dart';
import 'package:babyshophub_admin/providers/product_provider.dart';
import 'package:babyshophub_admin/providers/user_provider.dart';
import 'package:babyshophub_admin/screens/auth/auth_check.dart';
import 'package:babyshophub_admin/services/auth_service.dart';
import 'package:babyshophub_admin/services/review_service.dart';
import 'package:babyshophub_admin/theme/theme.dart';
import 'package:babyshophub_admin/theme/theme_provider.dart';
import 'package:wiredash/wiredash.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ReviewService>(create: (_) => ReviewService()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return Wiredash(
            projectId: 'babyshophub-gxx93v1',
            secret: 'R9nqP0ftC8uyhwQVIvf-x6-L_hiPHCBp',
            child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BabyShopHub Admin',
            theme: themeProvider.themeData,
            darkTheme: const BabyShopHubTheme().darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthCheck(),
            ),
          );
        },
      ),
    );
  }
}