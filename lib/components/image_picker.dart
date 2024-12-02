import 'dart:html' as html;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:nusantara_recipe/appwrite_storage.dart';
import 'package:flutter/material.dart';

export 'package:image_picker/image_picker.dart';

class ImagePickerNotifier extends StateNotifier<Uint8List?> {
  ImagePickerNotifier() : super(null);

  final ImagePicker _picker = ImagePicker();
  final AppwriteStorage _appwriteStorage = AppwriteStorage();
  XFile? _selectedImageFile;

  Future<void> uploadImage( WidgetRef ref) async {
    
    if (state != null && _selectedImageFile != null) {
      final imageUrl = await _appwriteStorage.uploadImageToAppwrite(state!, _selectedImageFile!.name, ref);
      ref.read(imageUrlProvider.notifier).updateImageUrl(imageUrl);
    }
  }

  Future<void> pickImage() async {
  if (kIsWeb) {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((e) {
          state = reader.result as Uint8List;
          _selectedImageFile = XFile(file.name);
        });
      }
    });
  } else {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      state = bytes;
      _selectedImageFile = pickedFile;
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
