import 'package:flutter/material.dart';
import 'package:nusantara_recipe/form.dart';
import 'package:nusantara_recipe/home.dart';
import 'package:nusantara_recipe/profile.dart';
import 'package:nusantara_recipe/save.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  
  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const RecipeForm(),
    const RecipeSave(),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: 'Posting',
          ),
          NavigationDestination(
            icon: Icon(Icons.playlist_add_outlined),
            label: 'Simpan',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}