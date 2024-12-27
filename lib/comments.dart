import 'package:flutter/material.dart';

class CommentsRecipe extends StatefulWidget {
  const CommentsRecipe({super.key});

  @override
  State<CommentsRecipe> createState() => _CommentsRecipeState();
}

class _CommentsRecipeState extends State<CommentsRecipe> {
  // Controller untuk TextField
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasi Padang'),
      ),
      body: Column(
        children: [
          // Daftar komentar
          Expanded(
            child: ListView(
              children: [
                // Komentar pertama
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar pengguna
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      // Kolom komentar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Nama pengguna
                            Text(
                              'user1',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            // Komentar
                            SizedBox(height: 4),
                            Text(
                              'Wah Enak Sekali Resepnya!',
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Komentar kedua
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar pengguna
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      // Kolom komentar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Nama pengguna
                            Text(
                              'user2',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            // Komentar
                            SizedBox(height: 4),
                            Text(
                              'Penasaran ingin mencoba!',
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Input komentar dan tombol kirim
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Input komentar
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Tulis komentar...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                ),
                // Tombol kirim
                IconButton(
                  onPressed: () {
                    // Tindakan kirim komentar (boleh diisi sesuai kebutuhan)
                    _commentController.clear(); // Kosongkan setelah kirim
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
