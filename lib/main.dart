import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
      ),
        body: SingleChildScrollView(
          child: Center(
            child: Builder(
              builder: (context) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: (){}, 
                              icon: Icon(
                                Icons.cookie,
                                size: 30.0,
                                )),
                            Expanded(
                              child:TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Search",
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: (){}, 
                              icon: Icon(
                                Icons.notifications,
                                size: 30.0,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Mengikuti',textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)),
                            Expanded(
                              child: Text('Inspirasi',textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)),
                            
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Apa isi kulkasmu?", style: TextStyle(fontSize: 16),),
                            Text("Pilih hingga 3 bahan", style: TextStyle(fontSize: 12),),
                          ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 20, left: 10),
                        child: Row(
                          children: [
                            ElevatedButton(onPressed: (){}, child: Text('Ayam')),
                            ElevatedButton(onPressed: (){}, child: Text('Tahu')),
                            ElevatedButton(onPressed: (){}, child: Text('Tempe')),
                          ],
                        ),
                      ),
                      Container(
                        color:Colors.orange[400],
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text('Semua',style: TextStyle(color: Colors.white),),
                            )
                          ],
                        )
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        child: Image.asset('images/nasi-goreng.jpg')),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Expanded(
                          child: ElevatedButton(
                            onPressed: (){}, 
                            child: Text('Temukan ide lainnya'))),
                      )
            
                      
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}