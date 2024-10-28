import 'package:flutter/material.dart';

class MyRecipe extends StatefulWidget {
  const MyRecipe({super.key});

  @override
  State<MyRecipe> createState() => _MyRecipeState();
}

class _MyRecipeState extends State<MyRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Simpan semua masakanmu dalam satu tempat'),
            Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                      onPressed: () {}, 
                      child: const Text('Tulis Resep'),
                    ),
            ),
          ],
        )
        ),
    );
  }
}