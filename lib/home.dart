import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/components/ishover.dart';
import 'package:nusantara_recipe/components/search.dart';
import 'package:nusantara_recipe/recipe/detail.dart';
import 'package:nusantara_recipe/recipe/recipe_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();

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
                    // Header
                    HeaderSearch(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: IsHover(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                alignment: Alignment.center,
                                child: Text(
                                  'Mengikuti',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: IsHover(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                alignment: Alignment.center,
                                child: Text(
                                  'Inspirasi',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
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
                    // Menampilkan semua resep
                    ListView.builder(
                      shrinkWrap: true, // Agar ListView tidak membatasi ukuran
                      physics: NeverScrollableScrollPhysics(), // Matikan scroll pada ListView
                      itemCount: recipeList.length,
                      itemBuilder: (context, index) {
                        final recipeData = recipeList[index].data() as Map<String, dynamic>;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: IsHover(
                              onTap: (){
                                    Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailRecipePage(recipeData: recipeData),
                                          ),
                                        );
                                      },
                              borderRadius: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {},
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
