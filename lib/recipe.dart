import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusantara_recipe/recipe/detail.dart';
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
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(right: 16),
                              child: const Icon(Icons.book, size: 50.0, color: Colors.deepOrange),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipeData['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    recipeData['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(context, recipeId);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          _showUpdateDialog(context, recipeId, recipeData);
                                        },
                                      ),
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
                      ),
                    );
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

  // Dialog konfirmasi hapus
  void _showDeleteConfirmationDialog(BuildContext context, String recipeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Resep'),
          content: const Text('Apakah Anda yakin ingin menghapus resep ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _recipeService.deleteRecipe(recipeId).then((_) {
                  Navigator.of(context).pop(); // Menutup dialog setelah menghapus
                }).catchError((error) {
                  print('Error deleting recipe: $error');
                });
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Dialog untuk memperbarui resep
  void _showUpdateDialog(BuildContext context, String recipeId, Map<String, dynamic> recipeData) {
    final nameController = TextEditingController(text: recipeData['name']);
    final descriptionController = TextEditingController(text: recipeData['description']);
    final ingredientsController = TextEditingController(text: recipeData['ingredients'].join(', '));
    final stepsController = TextEditingController(text: recipeData['steps'].join(', '));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Perbarui Resep'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Resep'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              TextField(
                controller: ingredientsController,
                decoration: const InputDecoration(labelText: 'Bahan (pisahkan dengan koma)'),
              ),
              TextField(
                controller: stepsController,
                decoration: const InputDecoration(labelText: 'Langkah (pisahkan dengan koma)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                List<String> ingredients = ingredientsController.text.split(',').map((ingredient) => ingredient.trim()).toList();
                List<String> steps = stepsController.text.split(',').map((step) => step.trim()).toList();
                String? userId = FirebaseAuth.instance.currentUser?.uid;

                _recipeService.updateRecipe(
                  recipeId,
                  nameController.text,
                  descriptionController.text,
                  ingredients,
                  steps,
                  userId,
                ).then((_) {
                  Navigator.of(context).pop(); // Menutup dialog setelah memperbarui
                }).catchError((error) {
                  print('Error updating recipe: $error');
                });
              },
              child: const Text('Perbarui'),
            ),
          ],
        );
      },
    );
  }
}
