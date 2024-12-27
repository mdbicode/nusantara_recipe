import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/components/header_search.dart';
import 'package:nusantara_recipe/components/ishover.dart';
import 'package:nusantara_recipe/recipe/detail.dart';
import 'package:nusantara_recipe/service/recipe_service.dart';

class InspirationPage extends StatefulWidget {
  final String initialQuery;

  const InspirationPage({super.key, required this.initialQuery});

  @override
  State<InspirationPage> createState() => _InspirationPageState();
}

class _InspirationPageState extends State<InspirationPage> {
  final RecipeService _recipeService = RecipeService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderSearch(
            onSearch: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _recipeService.getRecipesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
      
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }
      
                List recipeList = snapshot.data!.docs;
      
                List filteredRecipes = recipeList.where((recipe) {
                  final recipeData = recipe.data() as Map<String, dynamic>;
                  final name = recipeData['name']?.toLowerCase() ?? ''; // Handle null safety
                  return name.contains(_searchQuery.toLowerCase());
                }).toList();
      
                return filteredRecipes.isEmpty
                    ? const Center(child: Text('Tidak ada resep ditemukan.'))
                    : ListView.builder(
                        itemCount: filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipeData = filteredRecipes[index].data() as Map<String, dynamic>;
                          final recipeId = filteredRecipes[index].id;
      
                          return RecipeCard(
                            recipeData: recipeData,
                            recipeId: recipeId,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailRecipePage(
                                    recipeData: recipeData,
                                    recipeId: recipeId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipeData;
  final String recipeId;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipeData,
    required this.recipeId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: SizedBox(
        height: 200,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: IsHover(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailRecipePage(
                    recipeData: recipeData,
                    recipeId: recipeId,
                  ),
                ),
              );
            },
            borderRadius: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  // Background image
                  recipeData['imageUrl'] != null && recipeData['imageUrl'].isNotEmpty
                      ? Image.network(
                          recipeData['imageUrl'],
                          width: double.infinity,
                          height: 200.0, // Atur tinggi sesuai kebutuhan
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: double.infinity,
                          height: 200.0,
                          color: Colors.deepOrange.withOpacity(0.1),
                          child: const Icon(
                            Icons.book,
                            size: 60.0,
                            color: Colors.deepOrange,
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            recipeData['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            recipeData['description'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
