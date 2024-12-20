import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nusantara_recipe/appwrite_storage.dart';
import 'package:nusantara_recipe/models/recipe_model.dart';
export 'package:nusantara_recipe/models/recipe_model.dart';

class RecipeService {
  final CollectionReference recipes = FirebaseFirestore.instance.collection('recipes');
  
  final _appwriteStorage = AppwriteStorage();

  Future<void> addRecipe(RecipeModel recipe) async {
    await recipes.add(recipe.toJson());
  }

  Future<void> updateRecipe(String recipeId, RecipeModel recipe) async {
      await recipes.doc(recipeId).update(recipe.toJson());
  }

Future<void> deleteImage(String? imageUrl, WidgetRef ref) async {
  if (imageUrl == null || imageUrl.isEmpty) {
    return;
  }

  List<String> parts = imageUrl.split('/');
  final imageId = parts[8];
  await _appwriteStorage.deleteImageFromAppwrite(imageId, ref);
}


Future<void> deleteRecipe(String recipeId, WidgetRef ref) async {
    await recipes.doc(recipeId).delete();
}

Stream<QuerySnapshot> getRecipesStream() {
  return recipes.orderBy('timestamp', descending: true).snapshots();
}

Future<DocumentSnapshot> getRecipeById(String recipeId) async {
  return await recipes.doc(recipeId).get();
}


Stream<QuerySnapshot> getRecipesStreamById(String? userId) {
  return recipes.where('userId', isEqualTo: userId).snapshots();
}


}


