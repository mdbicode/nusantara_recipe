import 'package:flutter/material.dart';
import 'package:nusantara_recipe/auth/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool _obscureText = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> signInWithEmailAndPassword() async {
    try{
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Anda berhasil login")),
        );
        Navigator.of(context).pop();
    } on FirebaseAuthException catch (e){
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Anda salah memasukkan data!")),
        );
      });
    }
    
  }


  @override
  Widget build(BuildContext context) {
     final message = ModalRoute.of(context)?.settings.arguments as String?;

    

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
          if (message != null)
            Text(
              message,
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          Container(
            padding: EdgeInsets.only(top:20),
            child: Text('Masuk',style: TextStyle(fontSize: 24),)),
          Container(
            padding: EdgeInsets.only(bottom:10),
            child: Text('Masak makin menyenangkan!')),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            margin: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                  ),
          ),
          Container(
            padding: EdgeInsets.only(top:15.0),
            margin: EdgeInsets.symmetric(horizontal: 50.0),
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
            padding: EdgeInsets.only(top:15.0),
            margin: EdgeInsets.symmetric(horizontal: 50.0),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signInWithEmailAndPassword, 
                child: Text('Masuk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[400],
                  foregroundColor: Colors.white
                ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top:15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum Punya Akun? '),
                MouseRegion(
                  cursor: SystemMouseCursors.click, // Mengatur kursor menjadi klik saat hover
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Daftar',style: TextStyle(color: Colors.blue[900]),),
                  )
                ),
              ],
            )

          ),
          
        ]

      ),
    ),
    );
  }
}