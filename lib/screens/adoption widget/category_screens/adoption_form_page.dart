import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetAdoptionFormPage extends StatefulWidget {
  final String petName;
  final String PetId;

  const PetAdoptionFormPage({
    super.key,
    required this.petName,
    required this.PetId,
  });

  @override
  State<PetAdoptionFormPage> createState() => _PetAdoptionFormPageState();
}

class _PetAdoptionFormPageState extends State<PetAdoptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? trainingPlan;
  String? hadPetBefore;
  String? caretaker;
  String? backupCaretaker;
  String? livingSituation;
  String? otherAnimals;

  String? userId;
  String? userEmail;
  String? userPhone;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data();
          setState(() {
            userId = user.uid;
            userEmail = data?['email'];
            userPhone = data?['phone']; // Fetching phone from Firestore
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user info: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && userId != null) {
      _formKey.currentState!.save();

      try {
        // Generate a unique formId
        final formId = '${userId}_${widget.PetId}_${DateTime.now().millisecondsSinceEpoch}';

        // Save the adoption form details along with PetId and userId
        await FirebaseFirestore.instance.collection('PetAdoptionForm').add({
          'formId': formId, // Unique form ID
          'PetId': widget.PetId, // Pet ID
          'userId': userId, // User ID
          'How do you plan on training your pet?': trainingPlan,
          'Have you ever had a pet before?': hadPetBefore,
          'Who will be the primary caretaker for the pet?': caretaker,
          'Who will care for your pet if you’re unable to?': backupCaretaker,
          'What’s your living situation?': livingSituation,
          'What other animals do you have at home?': otherAnimals,
          'createdAt': DateTime.now(), // Timestamp
        });

        // Save the adoption request with user info and pet details
        await FirebaseFirestore.instance.collection('AdoptionRequests').add({
          'requestId': formId, // Reusing the same unique form ID
          'petName': widget.petName,
          'PetId': widget.PetId,
          'userId': userId,
          'userEmail': userEmail,
          'phone': userPhone, // Storing phone in Firebase
          'createdAt': DateTime.now(),
          'status': 'Pending',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adoption request submitted successfully!')),
        );
        Navigator.pop(context); // Close the page after submission
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption Form'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Adopt ${widget.petName}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'How do you plan on training your pet?'),
                onSaved: (value) => trainingPlan = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Have you ever had a pet before?'),
                onSaved: (value) => hadPetBefore = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Who will be the primary caretaker for the pet?'),
                onSaved: (value) => caretaker = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Who will care for your pet if you’re unable to?'),
                onSaved: (value) => backupCaretaker = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'What’s your living situation?'),
                onSaved: (value) => livingSituation = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'What other animals do you have at home?'),
                onSaved: (value) => otherAnimals = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Adoption Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
