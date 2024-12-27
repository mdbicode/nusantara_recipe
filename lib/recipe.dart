import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:nusantara_recipe/recipe/detail.dart';
import 'package:nusantara_recipe/recipe/edit.dart';
import 'package:nusantara_recipe/service/recipe_service.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
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
                    final recipeId = recipeList[index].id;

                    return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRecipePage(recipeData: recipeData, recipeId: recipeId),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            recipeData['imageUrl'] != null && recipeData['imageUrl'].isNotEmpty
                                ? Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        recipeData['imageUrl'],
                                        width: 80.0, // Lebih kecil
                                        height: 80.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.only(right: 12), // Margin lebih kecil
                                    width: 80.0,
                                    height: 80.0,
                                    child: const Icon(
                                      Icons.book,
                                      size: 40.0, // Ikon lebih kecil
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                            // Text Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipeData['name'],
                                    style: const TextStyle(
                                      fontSize: 18, // Font lebih kecil
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4), // Jarak lebih kecil
                                  Text(
                                    recipeData['description'],
                                    style: TextStyle(
                                      fontSize: 13, // Font lebih kecil
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis, // Batasi teks
                                  ),
                                  const SizedBox(height: 12), // Jarak lebih kecil
                                  // Action Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.info_outline, size: 20), // Ikon lebih kecil
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailRecipePage(recipeData: recipeData, recipeId: recipeId),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20, color: Colors.blue), // Ikon lebih kecil
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditRecipePage(recipeId: recipeId),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20, color: Colors.red), // Ikon lebih kecil
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(context, recipeId, recipeData['imageUrl']);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );},
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
