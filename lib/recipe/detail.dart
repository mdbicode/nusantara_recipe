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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0,top: 20.0, bottom: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              recipeData['imageUrl'] != null && recipeData['imageUrl'].isNotEmpty ?
                              Container(
                                child: Image.network(recipeData['imageUrl'],width: double.infinity,height: 300.0,fit: BoxFit.cover,),
                              margin: const EdgeInsets.only(bottom: 15.0),
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
      ),
    );
  }
}
