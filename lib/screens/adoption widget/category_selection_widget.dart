import 'package:flutter/material.dart';
import 'category_screens/Small_Pet_Page.dart';
import 'category_screens/bird_page.dart';
import 'category_screens/cat_page.dart';
import 'category_screens/dog_page.dart';  // Import the DogPage


class CategorySelectionPage extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelectionPage({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: [
          _buildCategoryChip('Dogs', context),
          _buildCategoryChip('Cats', context),
          _buildCategoryChip('Birds', context),
          _buildCategoryChip('Small Pets', context),
        ],
      ),
    );
  }

  // Method to create a category chip
  Widget _buildCategoryChip(String category, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        label: Text(category),
        selected: selectedCategory == category,
        onSelected: (isSelected) {
          // Send selected category back to the parent
          onCategorySelected(category);

          // Navigate to the corresponding page based on category
          _navigateToCategoryPage(category, context);
        },
      ),
    );
  }

  // Method to navigate to the specific page based on the selected category
  void _navigateToCategoryPage(String category, BuildContext context) {
    switch (category) {
      case 'Dogs':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DogPage()), // Navigate to Dog Page
        );
        break;
      case 'Cats':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CatPage()), // Navigate to Cat Page
        );
        break;
      case 'Birds':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BirdPage()), // Navigate to Bird Page
        );
        break;
      case 'Small Pets':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SmallPetPage()), // Navigate to Small Pet Page
        );
        break;
      default:
        break;
    }
  }
}
