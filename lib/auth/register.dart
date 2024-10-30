import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage = '';
  bool isLogin = true;


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 Future<void> createUserWithEmailAndPassword() async {
  try{
    await Auth().createUserWithEmailAndPassword(
      email: _emailController.text, 
      password: _passwordController.text
      );
      Navigator.pushNamed(context, '/login', arguments: 'Akun berhasil dibuat!');
  } on FirebaseAuthException catch (e){
    setState(() {
      errorMessage = e.message;
      Navigator.pushNamed(context, '/login', arguments: errorMessage);
    });
  }
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.pop(context);
            } 
       ),
    ),
    body: Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top:20),
            child: const Text('Daftar',style: TextStyle(fontSize: 24),)),
          Container(
            padding: const EdgeInsets.only(bottom:10),
            child: const Text('Isi data pribadi anda!')),
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.only(top:15.0),
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Phone Number",
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.only(top:15.0),
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.only(top:15.0),
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.only(top:15.0),
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: createUserWithEmailAndPassword,
                child: const Text('Daftar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[400],
                  foregroundColor: Colors.white
                ),
                )),
          ),
        ]

      ),
    ),
    );
  }
}