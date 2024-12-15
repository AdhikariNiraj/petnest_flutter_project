import 'dart:convert'; // Add to decode base64 image
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'adoption_form_page.dart';

class DogProfilePage extends StatelessWidget {
  final String name;
  final String breed;
  final String age;
  final String sex;
  final String dogImage;
  final String about;
  final String PetId;
  final String price;

  const DogProfilePage({
    super.key,
    required this.name,
    required this.breed,
    required this.age,
    required this.sex,
    required this.dogImage,
    required this.about,
    required this.PetId, // Using PetId with capital P and I
    required this.price,
    required String phone,
  });

  @override
  Widget build(BuildContext context) {
    // Decode the base64 dog image
    Uint8List? decodedImage;
    if (dogImage.isNotEmpty) {
      try {
        decodedImage = base64Decode(dogImage); // Decode the base64 string
      } catch (e) {
        print('Error decoding image: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(color: Colors.black)), // Black color for app bar title
        centerTitle: true,
        backgroundColor: Colors.blue, // Blue background for app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Pet Image
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: decodedImage != null
                      ? Image.memory(
                    decodedImage,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Pet Information Card
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        about,
                        style: const TextStyle(fontSize: 16, color: Colors.black54, fontStyle: FontStyle.italic),
                      ),
                      const Divider(height: 20, thickness: 1),

                      // Pet Details
                      DetailRow(label: 'Name', value: name),
                      DetailRow(label: 'Breed', value: breed),
                      DetailRow(label: 'Age', value: age),
                      DetailRow(label: 'Sex', value: sex),
                      DetailRow(label: 'Price', value: price, valueColor: Colors.black), // Black price text
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Adopt Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1437cc), // Button color set to #0b1230
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetAdoptionFormPage(
                        petName: name,
                        PetId: PetId, // Pass PetId correctly here
                      ),
                    ),
                  );
                },
                child: const Text('Adopt this Pet', style: TextStyle(color: Colors.white)), // Button text color white
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A reusable widget to display pet details
class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
