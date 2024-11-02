import 'package:flutter/material.dart';
import 'package:nusantara_recipe/recipe.dart';
import 'package:nusantara_recipe/home.dart';
import 'package:nusantara_recipe/profile.dart';
import 'package:nusantara_recipe/collection.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  
  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const Recipe(),
    const Collection(),
    const Profile()
  ];

   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        height: 70,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '', // Label kosong
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_outlined),
                label: '', // Label kosong
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add_outlined),
                label: '', // Label kosong
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: '', // Label kosong
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            
            type: BottomNavigationBarType.fixed,
            iconSize: 27,
            ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}