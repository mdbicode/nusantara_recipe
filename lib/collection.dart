import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:nusantara_recipe/recipe/detail.dart';
import 'package:nusantara_recipe/service/favorites_service.dart';

class Collection extends StatefulWidget {
  const Collection({super.key});

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  final Auth _auth = Auth();
  final FavoritesService _favoriteService = FavoritesService();

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
      body: StreamBuilder<List<String>>(
        stream: _favoriteService.getFavoriteRecipeIdsByUser(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          }

          final recipeIdList = snapshot.data ?? [];

          if (recipeIdList.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada resep yang disukai.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Ambil data resep berdasarkan recipeId
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getRecipesByIds(recipeIdList),
            builder: (context, recipeSnapshot) {
              if (recipeSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (recipeSnapshot.hasError) {
                return Center(
                  child: Text('Terjadi kesalahan: ${recipeSnapshot.error}'),
                );
              }

              final recipes = recipeSnapshot.data ?? [];

              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  final recipeId = recipeIdList[index];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: const Icon(
                        Icons.book,
                        size: 40,
                        color: Colors.deepOrange,
                      ),
                      title: Text(
                        recipe['name'] ?? 'Resep Tidak Diketahui', // Tampilkan judul resep
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                            context,
                            userId,
                            recipeId,
                          );
                        },
                      ),
                      onTap: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRecipePage(
                              recipeData: recipe, 
                              recipeId: recipeId
                              ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getRecipesByIds(List<String> recipeIds) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .where(FieldPath.documentId, whereIn: recipeIds)
          .get();

      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error fetching recipes: $e');
      return [];
    }
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

  void _showDeleteConfirmationDialog(BuildContext context, String userId, String recipeId) {
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
                      await _favoriteService.favoriteRecipeDelete(userId, recipeId);
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
