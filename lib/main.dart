import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/login.dart';
import 'package:nusantara_recipe/auth/register.dart';
import 'package:nusantara_recipe/layout.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
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
