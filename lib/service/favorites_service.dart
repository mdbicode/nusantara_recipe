import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusantara_recipe/models/favorites_model.dart';

class FavoritesService {
final CollectionReference favorites = FirebaseFirestore.instance.collection('favorites'); 

Future<void> favoriteRecipe(FavoritesModel favorite) async {
  try {
    final userQuerySnapshot = await favorites
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
      final favorites = FavoritesModel.fromJson(data as Map<String, dynamic>);
      print(favorites);
      return favorites.recipeId;
    } else {
      return [];
    }
  });
}

}