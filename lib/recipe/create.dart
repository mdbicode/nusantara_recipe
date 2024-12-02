import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nusantara_recipe/appwrite_storage.dart';
import 'package:nusantara_recipe/components/image_picker.dart';
import 'package:nusantara_recipe/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:nusantara_recipe/recipe/recipe_service.dart';


class CreateRecipePage extends ConsumerStatefulWidget {
  const CreateRecipePage({super.key});

  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends ConsumerState<CreateRecipePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  Uint8List? _selectedImageBytes;
  XFile? _selectedImageFile;


  final appwriteStorageProvider = Provider<Storage>((ref) {
    final client = ref.watch(appwriteClientProvider);
    return Storage(client);
  });

  final _imageHelper = const ImagePickerWidget();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  } 

  Future<void> _submitRecipe(WidgetRef ref) async {
    String? imageUrl = ref.read(imageUrlProvider);

    if (imageUrl == null || imageUrl.isEmpty) {
      print("No image uploaded yet.");
      return;
    }

    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final recipe = Recipe(
      _nameController.text.trim(),
      _descriptionController.text.trim(),
      _ingredientsController.text.split('\n').map((ingredient) => ingredient.trim()).where((ingredient) => ingredient.isNotEmpty).toList(),
      _stepsController.text.split('\n').map((step) => step.trim()).where((step) => step.isNotEmpty).toList(),
      userId,
      imageUrl,
      Timestamp.now(),
    );

    final _recipes = RecipeService();
    _recipes.addRecipe(recipe);

    _nameController.clear();
    _descriptionController.clear();
    _ingredientsController.clear();
    _stepsController.clear();

    setState(() {
      _selectedImageBytes = null;
      _selectedImageFile = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe added successfully!')));
    Navigator.pop(context);    
  }

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (message != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 5),
                child: Center(
                  child: Text(
                    'Buat Resep Masakan Kamu!',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text('Jadikan resep masakanmu dikenal oleh banyak orang.'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                child: Column(
                  children: [
                    _imageHelper
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
                      await ref.read(imagePickerProvider.notifier).uploadImage(ref);
                      _submitRecipe(ref);

                    },
                    child: Text('Simpan Resep'),
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
}
