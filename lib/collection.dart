import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/auth.dart';

class Collection extends StatefulWidget {
  const Collection({super.key});

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tidak ada resep yang tersimpan'),
                Container(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                          onPressed: () {}, 
                          child: const Text('Temukan resep lainnya'),
                        ),
                ),
              ],
            )
            ),);
}else{
return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tidak ada resep yang tersimpan'),
                Container(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          }, 
                          child: const Text('Silahkan login'),
                        ),
                ),
              ],
            )
            ),);
}
      });
      }}