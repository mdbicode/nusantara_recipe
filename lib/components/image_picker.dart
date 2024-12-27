import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/appwrite_storage.dart';

export 'package:image_picker/image_picker.dart';

class ImagePickerNotifier extends StateNotifier<Uint8List?> {
  ImagePickerNotifier() : super(null);

  final ImagePicker _picker = ImagePicker();
  final AppwriteStorage _appwriteStorage = AppwriteStorage();
  XFile? _selectedImageFile;
  String? _selectedImageName;

  Future<void> uploadImage(WidgetRef ref) async {
    if (state != null && _selectedImageFile != null) {
      final imageUrl = await _appwriteStorage.uploadImageToAppwrite(state!, _selectedImageFile!.name, ref);
      ref.read(imageUrlProvider.notifier).updateImageUrl(imageUrl);
    }
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        state = bytes;
        _selectedImageFile = pickedFile;
        _selectedImageName = pickedFile.name;
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        state = bytes;
        _selectedImageFile = pickedFile;
        _selectedImageName = pickedFile.name;
      }
    }
  }
}

class ImageUrlNotifier extends StateNotifier<String?> {
  ImageUrlNotifier() : super(null);

  void updateImageUrl(String? imageUrl) {
    state = imageUrl;
  }
}

final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, Uint8List?>((ref) {
  return ImagePickerNotifier();
});

class ImagePickerWidget extends ConsumerWidget {
  final String? oldImageUrl;

  const ImagePickerWidget({super.key, this.oldImageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImageBytes = ref.watch(imagePickerProvider);

    void _pickImage() {
      ref.read(imagePickerProvider.notifier).pickImage();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      child: Column(
        children: [
          if (oldImageUrl != null && oldImageUrl!.isNotEmpty && selectedImageBytes == null)
            Image.network(
              oldImageUrl!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          if (selectedImageBytes != null)
            Image.memory(
              selectedImageBytes,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Pilih Gambar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[400],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
