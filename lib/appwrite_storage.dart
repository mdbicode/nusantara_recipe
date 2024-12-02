import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:nusantara_recipe/main.dart';


final appwriteStorageProvider = Provider<Storage>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

final appwriteStorageProvider2 = Provider<Storage>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

class AppwriteStorage {
  Uint8List? imageBytes;
  String? fileName;

  Future<void> deleteImageFromAppwrite(String fileId, WidgetRef ref) async {
    final storage = ref.read(appwriteStorageProvider);
    await storage.deleteFile(
        bucketId: '67322b680007b602fe4b',
        fileId: fileId,
      );
  
  }

  Future<String> uploadImageToAppwrite(Uint8List imageBytes, String originalFileName, WidgetRef ref) async {
  final storage = ref.read(appwriteStorageProvider);
  
  final uniqueId = ID.unique();
 
  final uploadedFile = await storage.createFile(
    bucketId: '67322b680007b602fe4b',
    fileId: uniqueId,
    file: InputFile.fromBytes(
      bytes: imageBytes,
      filename: uniqueId,
    ),
  );

  String imageUrl = 'http://localhost/v1/storage/buckets/67322b680007b602fe4b/files/${uploadedFile.$id}/view?project=67322ae0001f8cb9a9d6';
  
  return imageUrl;
}
}

class ImageUrlNotifier extends StateNotifier<String?> {
  // Inisialisasi state dengan null
  ImageUrlNotifier() : super(null);

  // Fungsi untuk memperbarui URL gambar
  void updateImageUrl(String imageUrl) {
    state = imageUrl;
  }

  // Fungsi untuk menghapus URL gambar (clear state)
  void clearImageUrl() {
    state = null;
  }
}

// Provider untuk ImageUrlNotifier
final imageUrlProvider = StateNotifierProvider<ImageUrlNotifier, String?>((ref) => ImageUrlNotifier());
