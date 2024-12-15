import 'package:flutter/material.dart';
import '../category_selection_widget.dart';

class CatPage extends StatefulWidget {
  const CatPage({super.key});

  @override
  _CatPageState createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  String selectedCategory = 'Cats'; // Default category
  String searchQuery = ''; // Search query entered by the user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cats')), // Title for the page
      body: Column(
        children: [
          // Category Selection (Cats will be pre-selected)
          CategorySelectionPage(
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category; // Update the selected category
              });
            },
          ),
          const SizedBox(height: 16),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query on user input
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search), // Search icon
                hintText: 'Search by breed...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Rounded corners
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Display Message: No pets available for now
          const Expanded(
            child: Center(
              child: Text(
                'No pet cats available for now',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
