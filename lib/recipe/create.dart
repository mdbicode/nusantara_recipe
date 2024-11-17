import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusantara_recipe/recipe/recipe_service.dart';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  Uint8List? _selectedImageBytes; // Untuk menyimpan byte gambar
  XFile? _selectedImageFile; // Untuk file gambar di mobile

  final ImagePicker _picker = ImagePicker();
  late final Client client;
  late final Storage storage;
  String? uploadedFileId;

  @override
  void initState() {
    super.initState();
    // Konfigurasi Appwrite
    client = Client()
        .setEndpoint('http://localhost/v1') // Endpoint Appwrite
        .setProject('67322ae0001f8cb9a9d6') // Ganti dengan Project ID Anda
        .setSelfSigned(status: true);

    storage = Storage(client);
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isEmpty) return;
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((e) {
          setState(() {
            _selectedImageBytes = reader.result as Uint8List;
            _selectedImageFile = XFile(file.name);
          });
        });
      });
    } else {
      // Untuk perangkat mobile menggunakan Image Picker
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageFile = pickedFile;
        });
      }
    }
  }

  Future<String> uploadImageToAppwrite(Uint8List imageBytes, String fileName) async {

    String imageUrl = "";
      final uploadedFile = await storage.createFile(
        bucketId: '67322b680007b602fe4b',
        fileId: ID.unique(),
        file: InputFile.fromBytes(
          bytes: imageBytes,
          filename: ID.unique(),
        ),
      );

    setState(() {
      imageUrl = 'http://localhost/v1/storage/buckets/67322b680007b602fe4b/files/${uploadedFile.$id}/view?project=67322ae0001f8cb9a9d6';
    });

    return imageUrl;
  }

  void _submitRecipe() async {
    String imageUrl = "";

    if (_selectedImageBytes != null && _selectedImageFile != null) {
      imageUrl = await uploadImageToAppwrite(_selectedImageBytes!, _selectedImageFile!.name);
      print("Image URL: $imageUrl");
    }

    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final List<String> ingredients = _ingredientsController.text.split('\n').map((ingredient) => ingredient.trim()).toList();
    final List<String> steps = _stepsController.text.split('\n').map((step) => step.trim()).toList();

    await _recipeService.addRecipe(
      name: name,
      description: description,
      ingredients: ingredients,
      steps: steps,
      userId: userId,
      imageUrl: imageUrl,
    );

    _nameController.clear();
    _descriptionController.clear();
    _ingredientsController.clear();
    _stepsController.clear();

    setState(() {
      _selectedImageBytes = null;
      _selectedImageFile = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe added successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.pop(context);
          },
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
                child: Text(
                  'Jadikan resep masakanmu dikenal oleh banyak orang.',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                child: Column(
                  children: [
                    if (_selectedImageBytes != null)
                      Image.memory(
                        _selectedImageBytes!,
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
                    onPressed: _submitRecipe,
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }
}
