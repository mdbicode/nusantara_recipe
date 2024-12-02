import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nusantara_recipe/appwrite_storage.dart';
import 'package:nusantara_recipe/components/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusantara_recipe/recipe/recipe_service.dart';
import 'dart:typed_data';

class EditRecipePage extends ConsumerStatefulWidget {
  final String recipeId;

  const EditRecipePage({Key? key, required this.recipeId}) : super(key: key);

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends ConsumerState<EditRecipePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  
  String? _imageUrl;

  Future<void> _loadRecipe() async {
    try {
      final recipeDoc = await _recipeService.getRecipeById(widget.recipeId);

      if (recipeDoc.exists) {
        final recipeData = recipeDoc.data() as Map<String, dynamic>;
        _imageUrl = recipeData['imageUrl'] ?? '';

        setState(() {
          _nameController.text = recipeData['name'] ?? '';
          _descriptionController.text = recipeData['description'] ?? '';
          _ingredientsController.text =
              (recipeData['ingredients'] as List<dynamic>).join('\n');
          _stepsController.text =
              (recipeData['steps'] as List<dynamic>).join('\n');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep tidak ditemukan.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat resep: $e')),
      );
    }
  }


  Future<void> _updateRecipe(WidgetRef ref) async {
    String? imageUrl = ref.read(imageUrlProvider);

    if (imageUrl == null || imageUrl.isEmpty) {
      print("No image uploaded yet.");
      return;
    }

    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final updatedRecipe = Recipe(
      _nameController.text.trim(),
      _descriptionController.text.trim(),
      _ingredientsController.text.split('\n').map((ingredient) => ingredient.trim()).where((ingredient) => ingredient.isNotEmpty).toList(),
      _stepsController.text.split('\n').map((step) => step.trim()).where((step) => step.isNotEmpty).toList(),
      userId,
      imageUrl,
      Timestamp.now(),
    );

    try {
      await _recipeService.updateRecipe(widget.recipeId, updatedRecipe);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resep berhasil diperbarui!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui resep: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Resep'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding:  EdgeInsets.only(top: 7, bottom: 5),
                child: Center(
                  child: Text(
                    'Edit Resep Masakan Kamu!',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                child: Column(
                  children: [
                    ImagePickerWidget(oldImageUrl: _imageUrl),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nama Resep",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
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
                    onPressed: () async {
                      await _recipeService.deleteImage(_imageUrl ,ref);
                      await ref.read(imagePickerProvider.notifier).uploadImage(ref);
                      _updateRecipe(ref);
                    },
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
