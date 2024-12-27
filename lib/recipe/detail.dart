import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:nusantara_recipe/components/transparent_appbar.dart';
import 'package:nusantara_recipe/models/favorites_model.dart';
import 'package:nusantara_recipe/models/following_model.dart';
import 'package:nusantara_recipe/service/favorites_service.dart';
import 'package:nusantara_recipe/service/following_service.dart';

class DetailRecipePage extends StatefulWidget {
  final Map<String, dynamic> recipeData;
  final String recipeId;

  const DetailRecipePage({Key? key, required this.recipeData, required this.recipeId}) : super(key: key);

  @override
  _DetailRecipePageState createState() => _DetailRecipePageState();
}

class _DetailRecipePageState extends State<DetailRecipePage> {
  String userName = '';

  Future<void> _getUserName(String userId) async {
    try {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      setState(() {
        userName = userDoc.exists ? (userDoc['name'] ?? 'Unknown User') : 'Unknown User';
      });
    } catch (e) {
      setState(() {
        userName = 'Error fetching user';
      });
      print("Error fetching user: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserName(widget.recipeData['userId']);
  }

  @override
  Widget build(BuildContext context) {
    final _favoriteService = FavoritesService();
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final _addFavoriteRecipe = FavoritesModel(userId, [widget.recipeId], Timestamp.now());
    final _addFollowUser = FollowingModel(userId, [widget.recipeData['userId']], Timestamp.now());

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Gambar Resep
                widget.recipeData['imageUrl'] != null && widget.recipeData['imageUrl'].isNotEmpty
                    ? Image.network(
                        widget.recipeData['imageUrl'],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.grey[300],
                        child: const Center(child: Text('No Image')),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  final followingService = FollowingService();
                                  followingService.followUser(_addFollowUser);
                                },
                                child: const Text(
                                  "Ikuti",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  final followingService = FollowingService();
                                  followingService.followUser(_addFollowUser);
                                },
                                icon: const Icon(Icons.favorite, color: Colors.red),
                              ),
                              IconButton(
                                onPressed: () {
                                  _favoriteService.favoriteRecipe(_addFavoriteRecipe);
                                },
                                icon: const Icon(Icons.bookmark_add),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Nama Resep
                      Text(
                        widget.recipeData['name'],
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // Deskripsi Resep
                      Text(
                        widget.recipeData['description'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                      // Bahan-bahan
                      const Text(
                        'Bahan-bahan:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...widget.recipeData['ingredients'].map<Widget>((ingredient) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('- $ingredient', style: const TextStyle(fontSize: 16)),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      // Langkah-langkah
                      const Text(
                        'Langkah-langkah:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...widget.recipeData['steps'].map<Widget>((step) {
                        int index = widget.recipeData['steps'].indexOf(step);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${index + 1}. $step', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TransparentAppbar(),
          ),
        ],
      ),
    );
  }
}
