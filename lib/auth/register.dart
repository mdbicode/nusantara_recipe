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
  bool _obscureText = true;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();  

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

 Future<void> createUserWithEmailAndPassword() async {
  try{
    await Auth().createUserWithEmailAndPassword(
      email: _emailController.text, 
      password: _passwordController.text,
      name: _nameController.text,
      phone: _phoneController.text,
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
                    controller: _phoneController,
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
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
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