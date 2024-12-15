import 'dart:convert'; // For decoding base64 image
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petnest_flutter_project/screens/adoption%20widget/category_screens/pet_profile.dart';
import '../search.dart'; // Import SearchBarPage
import '../category_selection_widget.dart'; // Import CategorySelectionPage

class DogPage extends StatefulWidget {
  const DogPage({super.key});

  @override
  _DogPageState createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {
  String selectedCategory = 'Dogs'; // Default to 'Dogs'
  String searchQuery = ''; // Initialize the search query

  // Fetch IDs of confirmed pets from the AdoptionRequests collection
  Future<Set<String>> _fetchConfirmedPetIds() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('AdoptionRequests')
        .where('status', isEqualTo: 'Confirmed')
        .get();

    return snapshot.docs.map((doc) => doc['PetId'] as String).toSet();
  }

  // Fetch pet data dynamically from Firestore based on the selected category
  Future<List<Map<String, dynamic>>> _fetchPets() async {
    final confirmedPetIds = await _fetchConfirmedPetIds();

    final snapshot = await FirebaseFirestore.instance
        .collection(selectedCategory) // Dynamically fetch based on the category
        .get();

    return snapshot.docs.map((doc) {
      final petId = doc.id;
      if (confirmedPetIds.contains(petId)) {
        return null; // Exclude confirmed pets
      }
      return {
        'PetId': petId, // Use PetId with capital P and I
        'Name': doc['Name'] as String,
        'Breed': doc['Breed'] as String,
        'Age': doc['Age'] as String,
        'Sex': doc['Sex'] as String,
        'DogImage': doc['DogImage'] as String,
        'About': doc['About'] as String,
        'Price': doc['Price'] as String, // Fetch Price field from Firestore
      };
    }).whereType<Map<String, dynamic>>().toList(); // Filter out nulls
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopt a Pet'),
        backgroundColor: Colors.blue, // Set app bar to blue
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category selection
          CategorySelectionPage(
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category; // Update selected category
                searchQuery = ''; // Clear search query when switching categories
              });
            },
          ),
          const SizedBox(height: 16), // Spacing

          // Search bar
          SearchBarPage(
            onSearchChanged: (value) {
              setState(() {
                searchQuery = value; // Update search query
              });
            },
          ),
          const SizedBox(height: 16), // Spacing

          // Display pet grid
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>( // Fetch pets dynamically
              future: _fetchPets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching pets'));
                }

                final pets = snapshot.data ?? [];

                // Filter pets based on the search query
                final filteredPets = pets.where((pet) {
                  return pet['Breed']!
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }).toList();

                if (filteredPets.isEmpty) {
                  return const Center(child: Text('No pets found'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.8, // Adjust card height-to-width ratio
                  ),
                  itemCount: filteredPets.length,
                  itemBuilder: (context, index) {
                    final pet = filteredPets[index];

                    // Decode the base64 image string
                    Uint8List? decodedImage;
                    if (pet['DogImage'] != null && pet['DogImage']!.isNotEmpty) {
                      try {
                        decodedImage = base64Decode(pet['DogImage']!);
                      } catch (e) {
                        print('Error decoding image: $e');
                      }
                    }

                    return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigate to PetProfilePage with the pet details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DogProfilePage(
                                name: pet['Name']!,
                                breed: pet['Breed']!,
                                age: pet['Age']!,
                                sex: pet['Sex']!,
                                dogImage: pet['DogImage']!,
                                about: pet['About']!,
                                PetId: pet['PetId'], // Pass PetId correctly
                                price: pet['Price']!,
                                phone: '',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display image
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                  image: decodedImage != null
                                      ? DecorationImage(
                                    image: MemoryImage(decodedImage),
                                    fit: BoxFit.cover,
                                  )
                                      : const DecorationImage(
                                    image: AssetImage('assets/placeholder.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pet['Name']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.black, // Change name text to black
                                    ),
                                  ),
                                  Text(
                                    'Breed: ${pet['Breed']}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    pet['Price']!,  // Remove the '$' sign
                                    style: const TextStyle(
                                      fontSize: 14.0,  // Remove the bold font weight
                                      color: Colors.black, // Keep price text color black
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
