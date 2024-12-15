import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAdoptionFormPage extends StatelessWidget {
  final String userId;
  final String petId;

  const ViewAdoptionFormPage({
    super.key,
    required this.userId,
    required this.petId,
  });

  Future<Map<String, dynamic>?> _fetchAdoptionForm() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('PetAdoptionForm')
          .where('userId', isEqualTo: userId)
          .where('PetId', isEqualTo: petId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    } catch (e) {
      debugPrint('Error fetching adoption form: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption Form Details'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchAdoptionForm(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(snapshot.hasError
                  ? 'Error: ${snapshot.error}'
                  : 'No adoption form found.'),
            );
          }

          final formData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Form ID: ${formData['formId'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Training Plan', formData['How do you plan on training your pet?']),
                _buildInfoRow('Had Pet Before', formData['Have you ever had a pet before?']),
                _buildInfoRow('Primary Caretaker', formData['Who will be the primary caretaker for the pet?']),
                _buildInfoRow('Backup Caretaker', formData['Who will care for your pet if you’re unable to?']),
                _buildInfoRow('Living Situation', formData['What’s your living situation?']),
                _buildInfoRow('Other Animals', formData['What other animals do you have at home?']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
