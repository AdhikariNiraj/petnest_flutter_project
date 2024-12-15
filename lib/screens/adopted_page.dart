import 'dart:convert';
import 'dart:typed_data'; // Import added explicitly
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdoptedPetPage extends StatefulWidget {
  const AdoptedPetPage({super.key});

  @override
  State<AdoptedPetPage> createState() => _AdoptedPetPageState();
}

class _AdoptedPetPageState extends State<AdoptedPetPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? adoptedPetData; // To store the adopted pet data
  bool isLoading = true; // To handle loading state
  Uint8List? petImage; // To store the pet image as bytes
  String? petBreed; // To store the pet breed
  String? petAbout; // To store the pet about
  String? petAge; // To store the pet age
  String? petSex; // To store the pet sex

  @override
  void initState() {
    super.initState();
    _fetchAdoptedPetData(); // Fetch adopted pet data when the page is loaded
  }

  // Function to fetch adopted pet data and its image
  Future<void> _fetchAdoptedPetData() async {
    try {
      // Get the currently logged-in user's email
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Query the AdoptionRequests collection for the adoption request by userEmail
        QuerySnapshot<Map<String, dynamic>> adoptionRequest = await _firestore
            .collection('AdoptionRequests')
            .where('userEmail', isEqualTo: currentUser.email)
            .get();

        if (adoptionRequest.docs.isNotEmpty) {
          // Get the first document as there should be only one adoption request per user
          adoptedPetData = adoptionRequest.docs[0].data();

          // Get the PetId from the AdoptionRequests collection, check for null
          String? petId = adoptedPetData?['PetId'];
          if (petId != null && petId.isNotEmpty) {
            // Fetch the pet details from the Dogs collection using the PetId
            DocumentSnapshot<Map<String, dynamic>> petDoc = await _firestore
                .collection('Dogs')
                .doc(petId)
                .get();

            if (petDoc.exists) {
              setState(() {
                final base64Image = petDoc.data()?['DogImage']; // Updated field name
                if (base64Image != null && base64Image is String) {
                  petImage = Uint8List.fromList(base64Decode(base64Image)); // Decode Base64 to bytes
                }
                petBreed = petDoc.data()?['Breed']; // Updated field name
                petAbout = petDoc.data()?['About'];
                petAge = petDoc.data()?['Age'];
                petSex = petDoc.data()?['Sex'];
              });
            } else {
              setState(() {
                petImage = null; // If pet is not found in Dogs collection
                petBreed = null;
                petAbout = null;
                petAge = null;
                petSex = null;
              });
            }
          } else {
            setState(() {
              petImage = null; // If PetId is null or empty
              petBreed = null;
              petAbout = null;
              petAge = null;
              petSex = null;
            });
          }
        } else {
          // No adoption request found for this user
          adoptedPetData = {'error': 'No adoption request found for this user!'};
        }
      } else {
        // No user is logged in
        adoptedPetData = {'error': 'No user is logged in!'};
      }
    } catch (e) {
      // Error fetching data
      adoptedPetData = {'error': 'An error occurred: $e'};
    } finally {
      // Stop the loading state
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopted Pet Details'),
        backgroundColor: Colors.blue, // Set AppBar color to blue
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading spinner
          : adoptedPetData == null
          ? const Center(child: Text('No data found')) // No data available
          : adoptedPetData!['error'] != null
          ? Center(child: Text(adoptedPetData!['error'])) // Error message
          : _buildAdoptedPetLayout(), // Display pet details
    );
  }

  // Widget to display adopted pet details in a profile-like card
  Widget _buildAdoptedPetLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display pet image (with rounded container at the top)
            if (petImage != null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: MemoryImage(petImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Display pet name in a stylish text
            Center(
              child: Text(
                adoptedPetData?['petName'] ?? 'Unknown Pet',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Display pet about below the name
            if (petAbout != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  petAbout ?? 'No details available.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            // Card displaying the pet's details
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Phone', adoptedPetData?['phone']),
                    _buildInfoRow('Status', adoptedPetData?['status']),
                    _buildInfoRow('User Email', adoptedPetData?['userEmail']),
                    _buildInfoRow('Breed', petBreed),
                    _buildInfoRow('Age', petAge),
                    _buildInfoRow('Sex', petSex),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Display status message at the bottom
            if (adoptedPetData?['status'] == 'Confirmed')
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: Text(
                  "Your request has been confirmed! Congratulations on adopting your new pet!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (adoptedPetData?['status'] == 'Rejected')
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: Text(
                  "Sorry, your request has been rejected for some reason. Please try again later.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a row displaying label and value
  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Flexible(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
