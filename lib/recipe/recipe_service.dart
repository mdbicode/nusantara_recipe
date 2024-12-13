import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nusantara_recipe/appwrite_storage.dart';
import 'package:nusantara_recipe/models/favorites_recipe.dart';
import 'package:nusantara_recipe/models/recipe.dart';
export 'package:nusantara_recipe/models/recipe.dart';

class RecipeService {
  final CollectionReference recipes = FirebaseFirestore.instance.collection('recipes');
  final CollectionReference favorites = FirebaseFirestore.instance.collection('favorites');
  final _appwriteStorage = AppwriteStorage();

  Future<void> addRecipe(Recipe recipe) async {
    await recipes.add(recipe.toJson());
  }

  Future<void> updateRecipe(String recipeId, Recipe recipe) async {
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

Future<void> favoriteRecipe(FavoritesRecipe favorite) async {
  try {
    final userQuerySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('userId', isEqualTo: favorite.userId)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      final docRef = userQuerySnapshot.docs.first.reference;
      await docRef.update({
        'recipeId': FieldValue.arrayUnion(favorite.recipeId),
      });
    } else {
      await FirebaseFirestore.instance.collection('favorites').add(favorite.toJson());
    }
  } catch (e) {
    print('Error while updating favorites: $e');
    return;
  }

}
Future<void> favoriteRecipeDelete(String userId, String recipeId) async {
  try {
    await favorites
        .where('userId', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'recipeId': FieldValue.arrayRemove([recipeId]),
        });
      }
    });

    print('Recipe ID removed successfully from the list');
  } catch (error) {
    print('Error removing recipe ID: $error');
  }
}


Stream<List<String>> getFavoriteRecipeIdsByUser(String userId) {
  return favorites
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      final favorites = FavoritesRecipe.fromJson(data as Map<String, dynamic>);
      return favorites.recipeId;
    } else {
      return [];
    }
  });
}

}


