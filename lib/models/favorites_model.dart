

import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesModel{

final String userId;
final List<String> recipeId;
final Timestamp timestamp;

FavoritesModel(
  this.userId,
  this.recipeId,
  this.timestamp
);

FavoritesModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as String,
        recipeId = List<String>.from(json['recipeId'] as List),
        timestamp = json['timestamp'] as Timestamp;

Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'recipeId': recipeId,
      'timestamp': timestamp,
    };
  }
}