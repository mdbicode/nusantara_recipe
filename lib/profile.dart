import 'package:flutter/material.dart';
import 'package:nusantara_recipe/components/ishover.dart';
import 'auth/auth.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Auth _auth = Auth();
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
                  child:  Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(Icons.account_box,size: 120.0,)
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Selamat datang!', style: TextStyle(fontSize: 16)),
                              Text('${user?.email}', style: TextStyle(fontSize: 20)),
                              Text('Simpan dan posting resep, bagikan resep, dan lainnya.', style: TextStyle(fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    ),
                    IsHover(
                      onTap: (){},
                      child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
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
                            child: Icon(Icons.account_box,size: 150.0,)
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Masuk ke akunmu', style: TextStyle(fontSize: 18)),
                              Text('Simpan dan posting resep, bagikan resep, dan lainnya.', style: TextStyle(fontSize: 12)),
                            ],
                          )
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