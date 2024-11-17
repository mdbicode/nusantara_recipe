import 'package:flutter/material.dart';

class DetailRecipePage extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  const DetailRecipePage({Key? key, required this.recipeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(onPressed: (){}, icon: const Icon(Icons.add_box))
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            recipeData['imagePath'] != null && recipeData['imagePath'].isNotEmpty ?
                            Container(
                              child: Image.network(recipeData['imagePath'],width: double.infinity,height: 300.0,fit: BoxFit.cover,),
                            margin: const EdgeInsets.only(right: 20),
                            ):
                            Text('No Image'),
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
            const Text(
              'Bahan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...recipeData['ingredients'].map<Widget>((ingredient) {
              return Text('- $ingredient');
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              'Langkah:',
              style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
