import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusantara_recipe/models/following_model.dart';

class FollowingService {
final CollectionReference following = FirebaseFirestore.instance.collection('following');

Future<void> followUser(FollowingModel favorite) async {
  try {
    final userQuerySnapshot = await following
        .where('userId', isEqualTo: favorite.userId)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      final docRef = userQuerySnapshot.docs.first.reference;
      await docRef.update({
        'recipeId': FieldValue.arrayUnion(favorite.followId),
      });
    } else {
      await following.add(favorite.toJson());
    }
  } catch (e) {
    print('Error while updating following: $e');
    return;
  }

}
Future<void> followUserDelete(String userId, String recipeId) async {
  try {
    await following
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
Stream<List<String>> getFollowingByUser(String userId) {
  return following
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      final following = FollowingModel.fromJson(data as Map<String, dynamic>);
      return following.followId;
    } else {
      return [];
    }
  });
}
}