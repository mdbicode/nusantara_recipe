import 'dart:typed_data';   
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusantara_recipe/main.dart';

class RecipeService {
  final CollectionReference recipes = FirebaseFirestore.instance.collection('recipes');

  Future<void> addRecipe({
  required String name,
  required String description,
  required List<String> ingredients,
  required List<String> steps,
  String? imageUrl,
  String? userId,
}) async {
  try {
    await recipes.add({
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'userId': userId,
      'imagePath': imageUrl,
      'timestamp': Timestamp.now(),
    });

    print('Resep berhasil ditambahkan!');
  } catch (e) {
    print("Terjadi kesalahan saat menambahkan resep: $e");
  }
}


  // Fungsi untuk memperbarui resep di Firestore
  Future<void> updateRecipe(String recipeId, String name, String description, List<String> ingredients, List<String> steps, String? userId) async {
    try {
      await recipes.doc(recipeId).update({
        'name': name,
        'description': description,
        'ingredients': ingredients,
        'steps': steps,
        'userId': userId,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }

  // Fungsi untuk menghapus resep di Firestore
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await recipes.doc(recipeId).delete();
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }

  // Fungsi untuk membaca stream resep dari Firestore
  Stream<QuerySnapshot> getRecipesStream() {
    return recipes.orderBy('timestamp', descending: true).snapshots();
  }

  // Fungsi untuk mendapatkan resep berdasarkan ID
  Future<DocumentSnapshot> getRecipeById(String recipeId) async {
    return await recipes.doc(recipeId).get();
  }

  // Fungsi untuk mendapatkan stream resep berdasarkan userId
  Stream<QuerySnapshot> getRecipesStreamById(String? userId) {
    return recipes.where('userId', isEqualTo: userId).snapshots();
  }
}
