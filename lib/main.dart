import 'package:firebase_core/firebase_core.dart';
import 'package:nusantara_recipe/recipe/create.dart';
import 'firebase_options.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/login.dart';
import 'package:nusantara_recipe/auth/register.dart';
import 'package:nusantara_recipe/layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/create-recipe': (context) => CreateRecipePage(),
      },
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
      debugShowCheckedModeBanner: false,
      home: const Layout(), // Panggil widget dari home.dart
    );
  }
}
