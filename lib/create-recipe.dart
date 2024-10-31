import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/auth.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({super.key});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final Auth _auth = Auth();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        }

        if (snapshot.hasData) {

          User? user = snapshot.data;
          return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Simpan semua masakanmu dalam satu tempat'),
                Container(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                          onPressed: () {
                             Navigator.pushNamed(context, '/create-recipe');
                          }, 
                          child: const Text('Tulis Resep'),
                        ),
                ),
              ],
            )
            ),
        );;
        }else{
          return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Simpan semua masakanmu dalam satu tempat'),
                Container(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          }, 
                          child: const Text('Silahkan login'),
                        ),
                ),
              ],
            )
            ),
        );
        }
      }
    );
  }
}
