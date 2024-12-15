import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddDogPage extends StatefulWidget {
  const AddDogPage({super.key});

  @override
  _AddDogPageState createState() => _AddDogPageState();
}

class _AddDogPageState extends State<AddDogPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  Uint8List? _selectedImage;
  String? _editingDocId;

  final ImagePicker _picker = ImagePicker();

  void _addOrUpdateDog() {
    final String name = _nameController.text.trim();
    final String breed = _breedController.text.trim();
    final String age = _ageController.text.trim();
    final String about = _aboutController.text.trim();
    final String price = _priceController.text.trim();
    final String sex = _sexController.text.trim();

    if (name.isEmpty || breed.isEmpty || age.isEmpty || about.isEmpty || price.isEmpty || sex.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image.')),
      );
      return;
    }

    final dogImageBase64 = base64Encode(_selectedImage!);

    final dogData = {
      'Name': name,
      'Breed': breed,
      'Age': "$age Yrs",
      'About': about,
      'Price': "Rs $price",
      'Sex': sex,
      'DogImage': dogImageBase64,
    };

    if (_editingDocId == null) {
      // Add new dog
      FirebaseFirestore.instance.collection('Dogs').add({
        ...dogData,
        'PetId': FirebaseFirestore.instance.collection('Dogs').doc().id,
      });
    } else {
      // Update existing dog
      FirebaseFirestore.instance.collection('Dogs').doc(_editingDocId).update(dogData);
      _editingDocId = null; // Reset editing state
    }

    _clearFields();
  }

  void _deleteDog(String docId) {
    FirebaseFirestore.instance.collection('Dogs').doc(docId).delete();
  }

  void _clearFields() {
    _nameController.clear();
    _breedController.clear();
    _ageController.clear();
    _aboutController.clear();
    _priceController.clear();
    _sexController.clear();
    setState(() {
      _selectedImage = null;
      _editingDocId = null;
    });
  }

  void _loadDogData(Map<String, dynamic> dog, String docId) {
    _nameController.text = dog['Name'] ?? '';
    _breedController.text = dog['Breed'] ?? '';
    _ageController.text = dog['Age']?.replaceAll(' Yrs', '') ?? '';
    _aboutController.text = dog['About'] ?? '';
    _priceController.text = dog['Price']?.replaceAll('Rs ', '') ?? '';
    _sexController.text = dog['Sex'] ?? '';
    if (dog['DogImage'] != null && (dog['DogImage'] as String).isNotEmpty) {
      try {
        _selectedImage = base64Decode(dog['DogImage']);
      } catch (e) {
        print('Error decoding image: $e');
      }
    }
    _editingDocId = docId;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Dog')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _breedController,
              decoration: const InputDecoration(labelText: 'Breed'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _aboutController,
              decoration: const InputDecoration(labelText: 'About'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _sexController,
              decoration: const InputDecoration(labelText: 'Sex'),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: _pickImage,
              child: _selectedImage != null
                  ? Image.memory(_selectedImage!, height: 150, width: 150, fit: BoxFit.cover)
                  : Container(
                height: 150,
                width: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.add_a_photo, size: 50),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addOrUpdateDog,
              child: Text(_editingDocId == null ? 'Add Dog' : 'Save Changes'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Dog List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Dogs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching dogs'));
                }
                final dogs = snapshot.data?.docs ?? [];
                if (dogs.isEmpty) {
                  return const Center(child: Text('No dogs available'));
                }
                return Column(
                  children: dogs.map((doc) {
                    final dog = doc.data() as Map<String, dynamic>;
                    final docId = doc.id;

                    Uint8List? decodedImage;
                    if (dog['DogImage'] != null &&
                        dog['DogImage'] is String &&
                        (dog['DogImage'] as String).isNotEmpty) {
                      try {
                        decodedImage = base64Decode(dog['DogImage']);
                      } catch (e) {
                        print('Error decoding image: $e');
                      }
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: decodedImage != null
                            ? CircleAvatar(backgroundImage: MemoryImage(decodedImage))
                            : const CircleAvatar(child: Icon(Icons.image)),
                        title: Text(dog['Name'] ?? 'No name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Breed: ${dog['Breed'] ?? 'N/A'}'),
                            Text('About: ${dog['About'] ?? 'No details provided'}'),
                            Text('Age: ${dog['Age'] ?? 'N/A'}'),
                            Text('Price: ${dog['Price'] ?? 'N/A'}'),
                            Text('Sex: ${dog['Sex'] ?? 'N/A'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _loadDogData(dog, docId);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteDog(docId),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
