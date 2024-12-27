import 'package:flutter/material.dart';
import 'package:nusantara_recipe/layout.dart';
import 'package:nusantara_recipe/inspiration.dart';

class HeaderSearch extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const HeaderSearch({super.key, required this.onSearch});

  @override
  State<HeaderSearch> createState() => _HeaderSearchState();
}

class _HeaderSearchState extends State<HeaderSearch> {
  final TextEditingController _controller = TextEditingController();

  void _navigateToInspiration(BuildContext context, String query) {
    bool isInspirationOpen = false;

    Navigator.popUntil(context, (route) {
      if (route.settings.name == 'InspirationPage') {
        isInspirationOpen = true;
      }
      return true;
    });

    if (!isInspirationOpen) {
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: 'InspirationPage'),
          builder: (context) => InspirationPage(initialQuery: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Layout()),
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.cookie,
            size: 30.0,
          ),
        ),
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Cari resep...',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            widget.onSearch(value);
            _navigateToInspiration(context, value);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.onSearch(_controller.text);
              _navigateToInspiration(context, _controller.text);
            },
            icon: const Icon(Icons.search, size: 30.0),
          ),
        ],
      ),
    );
  }
}
