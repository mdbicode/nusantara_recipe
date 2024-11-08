import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:nusantara_recipe/recipe/recipe_service.dart';

class EditRecipePage extends StatefulWidget {
  final String recipeId;

  const EditRecipePage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
  try {
    final recipeDoc = await _recipeService.getRecipeById(widget.recipeId);
    
    if (recipeDoc.exists) {
      final recipeData = recipeDoc.data() as Map<String, dynamic>;
      
      setState(() {
        
        _nameController.text = recipeData['name'] ?? '';
        _descriptionController.text = recipeData['description'] ?? '';
        _ingredientsController.text = (recipeData['ingredients'] as List<dynamic>).join('\n');
        _stepsController.text = (recipeData['steps'] as List<dynamic>).join('\n');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe not found.'))
      );
      Navigator.pop(context);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load recipe: $e'))
    );
  }
}


  Future<void> _updateRecipe() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final List<String> ingredients = _ingredientsController.text.split('\n').map((e) => e.trim()).toList();
    final List<String> steps = _stepsController.text.split('\n').map((e) => e.trim()).toList();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    await _recipeService.updateRecipe(widget.recipeId, name, description, ingredients, steps, userId);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe updated successfully!')));
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Edit Resep Masakan Kamu!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Unggah Gambar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[400],
                  foregroundColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nama Resep",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Deskripsi Resep",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _ingredientsController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Bahan-Bahan",
                    hintText: "Masukkan setiap bahan, pisahkan dengan titik",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _stepsController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Langkah-Langkah",
                    hintText: "Deskripsikan langkah-langkah pembuatan resep",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateRecipe,
                    child: Text('Simpan Perubahan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[400],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }
}
