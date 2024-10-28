import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
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
                onPressed: (){}, 
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