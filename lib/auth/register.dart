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
            child: Text('Daftar',style: TextStyle(fontSize: 24),)),
          Container(
            padding: EdgeInsets.only(bottom:10),
            child: Text('Isi data pribadi anda!')),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            margin: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                    ),
                  ),
          ),
          Container(
            padding: EdgeInsets.only(top:15.0),
            margin: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Phone Number",
                    ),
                  ),
          ),
          Container(
            padding: EdgeInsets.only(top:15.0),
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
                child: Text('Daftar'),
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