import 'package:flutter/material.dart';
import 'package:nusantara_recipe/components/ishover.dart';
import 'auth/auth.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Auth _auth = Auth();
  String? userName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          User? user = snapshot.data;

          // Menggunakan FutureBuilder untuk mengambil data pengguna
          return FutureBuilder<Map<String, dynamic>?>(
            future: _auth.getUserData(user!.uid),
            builder: (context, userDataSnapshot) {
              if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (userDataSnapshot.hasData) {
                userName = userDataSnapshot.data?['name'];

                return Scaffold(
                  appBar: AppBar(
                    leading: Icon(Icons.settings),
                    title: Text('Pengaturan'),
                  ),
                  body: Column(
                    children: [
                      Container(
                        color: Colors.grey[200],
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(Icons.account_box, size: 120.0),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Selamat datang !', style: TextStyle(fontSize: 16)),
                                Text('${userName}', style: TextStyle(fontSize: 20)),
                                Container(
                                  width: 200,
                                  child: Text('Simpan dan posting resep, bagikan resep, dan lainnya.', style: TextStyle(fontSize: 12),softWrap: true,)
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                      IsHover(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Text('Negara'),
                              ),
                              Icon(Icons.navigate_next),
                            ],
                          ),
                        ),
                      ),
                      IsHover(
                        onTap: _auth.signOut,
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Logout'),
                              ),
                              Icon(Icons.navigate_next),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: Text('Data pengguna tidak ditemukan.'));
              }
            },
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(Icons.account_box, size: 150.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Masuk ke akunmu', style: TextStyle(fontSize: 18)),
                              Text('Simpan dan posting resep, bagikan resep, dan lainnya.', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
