import 'package:flutter/material.dart';

class HeaderSearch extends StatelessWidget {
  const HeaderSearch({super.key});

  @override
  Widget build(BuildContext context) {
   final TextEditingController _searchController = TextEditingController();

    return Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {}, 
                  icon: const Icon(
                    Icons.cookie,
                    size: 30.0,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Search",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: const Icon(
                    Icons.notifications,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          );
  }
}