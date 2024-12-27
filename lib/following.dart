import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nusantara_recipe/auth/auth.dart';
import 'package:nusantara_recipe/service/following_service.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final Auth _auth = Auth();
  final FollowingService _followingService = FollowingService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorScreen(snapshot.error);
        }

        return snapshot.hasData ? _buildfollowScreen() : _buildLoginPrompt();
      },
    );
  }

  Widget _buildfollowScreen() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Ikuti'),
      ),
      body: StreamBuilder<List<String>>(
        stream: _followingService.getFollowingByUser(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          }

          final followIdList = snapshot.data ?? [];
          if (followIdList.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada pengguna yang diikuti.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getUserByIds(followIdList),
            builder: (context, followSnapshot) {
              if (followSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (followSnapshot.hasError) {
                return Center(
                  child: Text('Terjadi kesalahan: ${followSnapshot.error}'),
                );
              }

              final follows = followSnapshot.data ?? [];

              return ListView.builder(
                itemCount: follows.length,
                itemBuilder: (context, index) {
                  final follow = follows[index];
                  final followId = followIdList[index];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: const Icon(
                        Icons.book,
                        size: 40,
                        color: Colors.deepOrange,
                      ),
                      title: Text(
                        follow['name'] ?? 'Follow Tidak Diketahui', // Tampilkan judul Follow
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                            context,
                            userId,
                            followId,
                          );
                        },
                      ),
                      onTap: () {
                         
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getUserByIds(List<String> followIds) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: followIds)
          .get();

      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error fetching follows: $e');
      return [];
    }
  }

  Widget _buildLoginPrompt() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Mulai ikuti koki yang hebat'),
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Silahkan login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(Object? error) {
    return Scaffold(
      body: Center(
        child: Text('Terjadi kesalahan: $error'),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String userId, String followId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
            return AlertDialog(
              title: const Text('Hapus Follow'),
              content: const Text('Apakah Anda yakin ingin menghapus follow ini?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      Navigator.of(context).pop();
                      await _followingService.followUserDelete(userId, followId);
                    } catch (error) {
                      print('Error deleting follow: $error');
                    }
                  },
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
