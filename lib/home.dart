import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/components/ishover.dart';
import 'package:nusantara_recipe/components/header_search.dart';
import 'package:nusantara_recipe/following.dart';
import 'package:nusantara_recipe/inspiration.dart';
import 'package:nusantara_recipe/recipe/detail.dart';
import 'package:nusantara_recipe/service/recipe_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          return SingleChildScrollView(
            child: Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderSearch(
                      onSearch: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: IsHover(
                              onTap: () {
                                    Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const FollowingPage() 
                                          ),
                                        );
                              },
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Mengikuti',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: IsHover(
                              onTap: () {
                                Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const InspirationPage(initialQuery: '',) 
                                          ),
                                        );
                              },
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Inspirasi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 1, bottom: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Apa isi kulkasmu?",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Pilih hingga 3 bahan",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 20, left: 10),
                      child: Row(
                        children: [
                          Container(margin: EdgeInsets.only(right: 7.0), child: ElevatedButton(onPressed: () {}, child: const Text('Ayam'))),
                          Container(margin: EdgeInsets.only(right: 7.0), child: ElevatedButton(onPressed: () {}, child: const Text('Tahu'))),
                          Container(margin: EdgeInsets.only(right: 7.0), child: ElevatedButton(onPressed: () {}, child: const Text('Tempe'))),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.orange[400],
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Semua',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipeList.length,
                      itemBuilder: (context, index) {
                        final recipeData = recipeList[index].data() as Map<String, dynamic>;
                        final recipeId = recipeList[index].id;
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
                                      // Caption overlay
                                      Positioned(
                                        bottom: 0, // Posisikan di bagian bawah
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.7), // Warna gelap di bawah
                                                Colors.transparent, // Transparan ke atas
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
                          )

                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                            Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const InspirationPage(initialQuery: '',) 
                                          ),
                                        );
                        },
                        child: const Text('Temukan ide lainnya'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
