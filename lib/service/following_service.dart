import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:nusantara_recipe/models/following_model.dart';

class FollowingService {
final CollectionReference following = FirebaseFirestore.instance.collection('following');

Future<void> followUser(FollowingModel favorite) async {

  try {
    final userQuerySnapshot = await following
        .where('userId', isEqualTo: favorite.userId)
        .get();
    if(favorite.userId == favorite.followId[0]){
      return;
    }
    if (userQuerySnapshot.docs.isNotEmpty) {
      final docRef = userQuerySnapshot.docs.first.reference;
      await docRef.update({
        'followId': FieldValue.arrayUnion(favorite.followId),
      });
    } else {
      await following.add(favorite.toJson());
    }
  } catch (e) {
    return;
  }

}
Future<void> followUserDelete(String userId, String followId) async {
  try {
    await following
        .where('userId', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'followId': FieldValue.arrayRemove([followId]),
        });
      }
    });
  } catch (error) {
    return;
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