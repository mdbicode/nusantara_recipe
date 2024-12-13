import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/auth.dart';
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
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? 'Unknown User';
        });
      } else {
        setState(() {
          userName = 'Unknown User';
        });
      }
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
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                _favoriteService.favoriteRecipe(_addFavoriteRecipe);
              },
              icon: const Icon(Icons.add_box),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: ElevatedButton(
                      onPressed: (){
                        final _followingService = FollowingService();
                        _followingService.followUser(_addFollowUser);
                      }, 
                    child: Text("Ikuti")),
                  )
                ],
              ),
              const SizedBox(height: 10),
              widget.recipeData['imageUrl'] != null && widget.recipeData['imageUrl'].isNotEmpty
                  ? Container(
                      child: Image.network(
                        widget.recipeData['imageUrl'],
                        width: double.infinity,
                        height: 300.0,
                        fit: BoxFit.cover,
                      ),
                      margin: const EdgeInsets.only(bottom: 15.0),
                    )
                  : const Text('No Image'),
              Text(
                widget.recipeData['name'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.recipeData['description'],
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bahan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...widget.recipeData['ingredients'].map<Widget>((ingredient) {
                return Text('- $ingredient');
              }).toList(),
              const SizedBox(height: 20),
              const Text(
                'Langkah:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...widget.recipeData['steps'].map<Widget>((step) {
                return Text('${widget.recipeData['steps'].indexOf(step) + 1}. $step');
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
