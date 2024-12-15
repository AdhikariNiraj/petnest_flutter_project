import 'package:flutter/material.dart';

class SearchBarPage extends StatelessWidget {
  final Function(String) onSearchChanged;

  const SearchBarPage({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onChanged: onSearchChanged, // Pass the search query up
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search pets by breed...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
