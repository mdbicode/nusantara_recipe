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
    const bucketId = '6755c062003997eafeaf';
    try {
    await storage.getFile(bucketId: bucketId, fileId: fileId);
    
    await storage.deleteFile(bucketId: bucketId, fileId: fileId);
  } catch (e) {
    return;
  }
  return;
  
  }

  Future<String> uploadImageToAppwrite(Uint8List imageBytes, String originalFileName, WidgetRef ref) async {
  final storage = ref.read(appwriteStorageProvider);
  
  final uniqueId = ID.unique();
 
  final uploadedFile = await storage.createFile(
    bucketId: '6755c062003997eafeaf',
    fileId: uniqueId,
    file: InputFile.fromBytes(
      bytes: imageBytes,
      filename: uniqueId,
    ),
  );

  String imageUrl = 'https://cloud.appwrite.io/v1/storage/buckets/6755c062003997eafeaf/files/${uploadedFile.$id}/view?project=67321b01003b0a385ebc&project=67321b01003b0a385ebc&mode=admin';
  
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
