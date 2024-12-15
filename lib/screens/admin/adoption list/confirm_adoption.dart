import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'adoption_form_page.dart';



class ConfirmAdoption extends StatefulWidget {
  final String adoptionRequestId;

  const ConfirmAdoption({super.key, required this.adoptionRequestId});

  @override
  State<ConfirmAdoption> createState() => _ConfirmAdoptionState();
}

class _ConfirmAdoptionState extends State<ConfirmAdoption> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? adoptedPetData;
  bool isLoading = true;
  Uint8List? petImage;
  String? petBreed;
  String? petAbout;
  String? petAge;
  String? petSex;

  @override
  void initState() {
    super.initState();
    _fetchAdoptedPetData();
  }

  Future<void> _fetchAdoptedPetData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> adoptionRequestSnapshot =
      await _firestore.collection('AdoptionRequests').doc(widget.adoptionRequestId).get();

      if (adoptionRequestSnapshot.exists) {
        adoptedPetData = adoptionRequestSnapshot.data();

        String? petId = adoptedPetData?['PetId'];
        if (petId != null && petId.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> petDoc =
          await _firestore.collection('Dogs').doc(petId).get();

          if (petDoc.exists) {
            setState(() {
              final base64Image = petDoc.data()?['DogImage'];
              if (base64Image != null && base64Image is String) {
                petImage = Uint8List.fromList(base64Decode(base64Image));
              }
              petBreed = petDoc.data()?['Breed'];
              petAbout = petDoc.data()?['About'];
              petAge = petDoc.data()?['Age'];
              petSex = petDoc.data()?['Sex'];
            });
          }
        }
      } else {
        adoptedPetData = {'error': 'Adoption request not found.'};
      }
    } catch (e) {
      adoptedPetData = {'error': 'Error occurred: $e'};
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updatePetStatus(String status) async {
    try {
      await _firestore
          .collection('AdoptionRequests')
          .doc(widget.adoptionRequestId)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adoption status updated to $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Adopted Pet Details'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : adoptedPetData == null || adoptedPetData!['error'] != null
          ? Center(child: Text(adoptedPetData?['error'] ?? 'No data available'))
          : _buildAdoptedPetLayout(),
    );
  }

  Widget _buildAdoptedPetLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Center(
              child: Text(
                adoptedPetData?['petName'] ?? 'Unknown Pet',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 10),
            if (petAbout != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  petAbout ?? 'No details available.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _updatePetStatus('Confirmed'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Confirm Adoption'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _updatePetStatus('Rejected'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Reject Adoption'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAdoptionFormPage(
                        userId: adoptedPetData?['userId'],
                        petId: adoptedPetData?['PetId'],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('View Adoption Form'),
              ),
            ),
          ],
        ),
      ),
    );
  }

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