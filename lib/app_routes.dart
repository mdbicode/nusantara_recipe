import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/login.dart';
import 'package:nusantara_recipe/auth/register.dart';
import 'package:nusantara_recipe/recipe/create.dart';

// Definisikan semua route di dalam map
Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  '/create-recipe': (context) => const CreateRecipePage(),
};
