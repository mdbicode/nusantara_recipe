import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeService {

  // Get Collection
  final CollectionReference recipes = FirebaseFirestore.instance.collection('recipes');

  // Dialog
  

  // Add
    Future<void> addRecipe( String name, String description,  List<String> ingredients, List<String> steps,){
      return recipes.add({
        'name' : name,
        'description' : description,
        'ingredients' : ingredients,
        'steps' : steps,
        'timestamp': Timestamp.now(),
    });
    }

  // READ 
    Stream<QuerySnapshot> getRecipesStream(){
      final recipesStream = recipes.orderBy('timestamp', descending: true).snapshots();
    
    return recipesStream;
    }
  }