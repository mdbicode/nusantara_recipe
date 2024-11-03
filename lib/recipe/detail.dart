import 'package:flutter/material.dart';

class DetailRecipePage extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  const DetailRecipePage({Key? key, required this.recipeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeData['name']),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipeData['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              recipeData['description'],
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Text(
              'Bahan:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...recipeData['ingredients'].map<Widget>((ingredient) {
              return Text('- $ingredient');
            }).toList(),
            const SizedBox(height: 20),
            Text(
              'Langkah:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...recipeData['steps'].map<Widget>((step) {
              return Text('${recipeData['steps'].indexOf(step) + 1}. $step');
            }).toList(),
          ],
        ),
      ),
    );
  }
}
