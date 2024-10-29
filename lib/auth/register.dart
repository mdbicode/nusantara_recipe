import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    try{
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
  await userCredential.user?.updateDisplayName(_nameController.text);
  await userCredential.user?.reload();
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: const Text("Pendaftaran berhasil")),
    );

  Navigator.pop(context); // Kembali ke halaman sebelumnya setelah mendaftar
  } on FirebaseAuthException catch (e) {
  print("Error code: ${e.code}"); // Menampilkan kode error di console
  String errorMessage;
  if (e.code == 'email-already-in-use') {
    errorMessage = 'Email sudah terdaftar.';
  } else if (e.code == 'weak-password') {
    errorMessage = 'Kata sandi terlalu lemah.';
  } else {
    errorMessage = 'Terjadi kesalahan. Coba lagi.';
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(errorMessage)),
  );
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
                onPressed: registerUser,
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