// home.dart
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/components/ishover.dart';
import 'package:nusantara_recipe/components/search.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                HeaderSearch(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: IsHover(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(15.0), 
                            alignment: Alignment.center, 
                            child: Text(
                              'Mengikuti',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: IsHover(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(15.0), 
                            alignment: Alignment.center, 
                            child: Text(
                              'Inspirasi',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Apa isi kulkasmu?",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Pilih hingga 3 bahan",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 20, left: 10),
                  child: Row(
                    children: [
                      Container(margin: EdgeInsets.only(right: 7.0), child: ElevatedButton(onPressed: () {}, child: const Text('Ayam'))),
                      Container(margin: EdgeInsets.only(right: 7.0), child: ElevatedButton(onPressed: () {}, child: const Text('Tahu'))),
                      Container(margin: EdgeInsets.only(right: 7.0), child: ElevatedButton(onPressed: () {}, child: const Text('Tempe'))),
                    ],
                  ),
                ),
                Container(
                  color: Colors.orange[400],
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Semua',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Image.asset('images/nasi-goreng.jpg'),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {}, 
                    child: const Text('Temukan ide lainnya'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
