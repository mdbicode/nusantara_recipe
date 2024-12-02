import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusantara_recipe/recipe/detail.dart';
import 'package:nusantara_recipe/recipe/edit.dart';
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
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Resep'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _recipeService.getRecipesStreamById(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          List recipeList = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: recipeList.length,
                  itemBuilder: (context, index) {
                    final recipeData = recipeList[index].data() as Map<String, dynamic>;
                    final recipeId = recipeList[index].id; // Mendapatkan ID resep

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image or Icon
                            recipeData['imageUrl'] != null && recipeData['imageUrl'].isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      recipeData['imageUrl'],
                                      width: 120.0,
                                      height: 120.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(right: 20),
                                width: 120.0,
                                height: 120.0,
                                child: const Icon(
                                  Icons.book,
                                  size: 60.0,
                                  color: Colors.deepOrange,
                                ),
                                ),
                            // Recipe Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Recipe Name
                                  Text(
                                    recipeData['name'],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Description
                                  Text(
                                    recipeData['description'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Bottom Row with buttons and text
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Detail Button
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailRecipePage(recipeData: recipeData),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.info_outline),
                                        label: const Text('Detail'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepOrange,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      // Delete Button
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(context, recipeId, recipeData['imageUrl']);
                                        },
                                      ),
                                      // Edit Button
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditRecipePage(recipeId: recipeId),
                                            ),
                                          );
                                        },
                                      ),
                                      // Ingredients Count
                                      Text(
                                        '${recipeData['ingredients'].length} Bahan',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                  
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/create-recipe');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Resep'),
                ),
              ),
            ],
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

  void _showDeleteConfirmationDialog(BuildContext context, String recipeId, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, child) {
          return AlertDialog(
            title: const Text('Hapus Resep'),
            content: const Text('Apakah Anda yakin ingin menghapus resep ini?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    Navigator.of(context).pop();
                    await _recipeService.deleteImage(imageUrl, ref);
                    await _recipeService.deleteRecipe(recipeId,ref);
                  } catch (error) {
                    print('Error deleting recipe: $error');
                  }
                },
                child: const Text('Hapus'),
              ),
            ],
          );
        },
      );
    },
  );
}

}
