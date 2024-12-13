import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:appwrite/appwrite.dart';
import 'package:nusantara_recipe/app_routes.dart';
import 'package:nusantara_recipe/layout.dart';

part 'main.g.dart';

@riverpod
Client appwriteClient (Ref ref){
  final client = Client();
  client.setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('67321b01003b0a385ebc')
        .setSelfSigned(status: true);
  return client;
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
    child: MyApp(),
  ));
} 


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      routes: appRoutes,
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
      home: const Layout(),
    );
  }
}