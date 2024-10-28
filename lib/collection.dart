import 'package:flutter/material.dart';

class Collection extends StatelessWidget {
  const Collection({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
    );
  }
}