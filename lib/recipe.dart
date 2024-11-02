import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusantara_recipe/recipe/recipe_service.dart';

class Recipe extends StatefulWidget {
  const Recipe({super.key});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  final Auth _auth = Auth();
  final RecipeService _recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorScreen(snapshot.error);
        }

        return snapshot.hasData ? _buildRecipeScreen() : _buildLoginPrompt();
      },
    );
  }

  Widget _buildRecipeScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Resep'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _recipeService.getRecipesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          List recipeList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: recipeList.length,
            itemBuilder: (context, index) {
              final recipeData = recipeList[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipeData['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(recipeData['description']),
                      SizedBox(height: 8),
                      Text('Bahan:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(recipeData['ingredients'].length, (stepIndex) {
                          return Text('${stepIndex + 1}. ${recipeData['ingredients'][stepIndex]}');
                        }),
                      ),
                      SizedBox(height: 8),
                      Text('Langkah:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(recipeData['steps'].length, (stepIndex) {
                          return Text('${stepIndex + 1}. ${recipeData['steps'][stepIndex]}');
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Simpan semua masakanmu dalam satu tempat'),
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Silahkan login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(Object? error) {
    return Scaffold(
      body: Center(
        child: Text('Terjadi kesalahan: $error'),
      ),
    );
  }
}