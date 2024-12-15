import 'package:flutter/material.dart';
import '../category_selection_widget.dart';

class SmallPetPage extends StatefulWidget {
  const SmallPetPage({super.key});

  @override
  _SmallPetPageState createState() => _SmallPetPageState();
}

class _SmallPetPageState extends State<SmallPetPage> {
  String selectedCategory = 'Small Pets'; // Default category
  String searchQuery = ''; // Search query entered by the user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Small Pets')), // Title for the page
      body: Column(
        children: [
          // Category Selection (Small Pets will be pre-selected)
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
                'No small pets available for now', // Bold message for no pets
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Make the text bold
                  fontSize: 18, // Set font size
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
