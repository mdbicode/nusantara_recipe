import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.navigate_before),
        title: Text('Pengaturan'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset('/images/nasi-goreng.jpg',height: 150, width: 150,),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Masuk ke akunmu', style: TextStyle(fontSize: 18),),
                    Text('Simpan dan posting resep, bagikan resep, dan lainnya.', style: TextStyle(fontSize: 12),),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(child:Text('Negara')),
                Icon(Icons.navigate_next)
              ],
            ),
          )
        ],
      ),
    );
  }
}