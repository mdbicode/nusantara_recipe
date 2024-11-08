import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeService {

  // Get Collection
  final CollectionReference recipes = FirebaseFirestore.instance.collection('recipes');

  // Dialog
  

  // Add
    Future<void> addRecipe( String name, String description,  List<String> ingredients, List<String> steps, String? userId){
      return recipes.add({
        'name' : name,
        'description' : description,
        'ingredients' : ingredients,
        'steps' : steps,
        'userId' : userId,
        'timestamp': Timestamp.now(),
    });
    }
    
    // Update Recipe
  Future<void> updateRecipe(String recipeId, String name, String description, List<String> ingredients, List<String> steps, String?  userId) async {
    try {
      await recipes.doc(recipeId).update({
        'name': name,
        'description': description,
        'ingredients': ingredients,
        'steps': steps,
         'userId' : userId,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }


     Future<void> deleteRecipe(String recipeId) async {
    try {
      await recipes.doc(recipeId).delete();
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }

  // READ 
    Stream<QuerySnapshot> getRecipesStream(){
      final recipesStream = recipes.orderBy('timestamp', descending: true).snapshots();
    
    return recipesStream;
    }
    
    Future<DocumentSnapshot> getRecipeById(String recipeId) async {
    return await recipes.doc(recipeId).get();
  }
    Stream<QuerySnapshot> getRecipesStreamById(String? userId){
      final recipesStream = recipes.where('userId', isEqualTo: userId).snapshots();
    
    return recipesStream;
    }
  }