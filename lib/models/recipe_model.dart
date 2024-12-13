import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String userId;
  final String imageUrl;
  final Timestamp timestamp;

  RecipeModel(
    this.name,
    this.description,
    this.ingredients,
    this.steps,
    this.userId, 
    this.imageUrl,
    this.timestamp,
  );

  RecipeModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        description = json['description'] as String,
        ingredients = List<String>.from(json['ingredients'] as List),
        steps = List<String>.from(json['steps'] as List),
        userId = json['userId'] as String,
        imageUrl = json['imageUrl'] as String,
        timestamp = json['timestamp'] as Timestamp;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'userId': userId,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}
