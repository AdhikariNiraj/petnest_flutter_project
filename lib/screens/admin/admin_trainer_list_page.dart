import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminTrainerAddPage extends StatefulWidget {
  const AdminTrainerAddPage({super.key});

  @override
  _AdminTrainerAddPageState createState() => _AdminTrainerAddPageState();
}

class _AdminTrainerAddPageState extends State<AdminTrainerAddPage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  final _nameController = TextEditingController();
  final _experienceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String? _docId;
  String _binaryImg = '';

  void _clearForm() {
    _nameController.clear();
    _experienceController.clear();
    _phoneController.clear();
    _locationController.clear();
    _categoryController.clear();
    _imageUrlController.clear();
    setState(() {
      _docId = null;
      _image = null;
      _binaryImg = '';
    });
  }

  void _saveTrainer() {
    if (_formKey.currentState!.validate()) {
      final trainerData = {
        'Name': _nameController.text,
        'Experience': _experienceController.text,
        'Phone': _phoneController.text,
        'Location': _locationController.text,
        'Category': _categoryController.text,
        'ImgUrl': _binaryImg,
      };

      if (_docId == null) {
        FirebaseFirestore.instance.collection('TrainerList').add(trainerData).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trainer Added')));
        }).catchError((error) {
          print('Error adding trainer: $error');
        });
      } else {
        FirebaseFirestore.instance.collection('TrainerList').doc(_docId).update(trainerData).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trainer Updated')));
        }).catchError((error) {
          print('Error updating trainer: $error');
        });
      }

      _clearForm();
    }
  }

  void _confirmDeleteTrainer(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Trainer"),
        content: const Text("Are you sure you want to delete this trainer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('TrainerList').doc(docId).delete().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trainer Deleted')));
              }).catchError((error) {
                print('Error deleting trainer: $error');
              });
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> uploadImg() async {
    final XFile? pickedImg = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImg != null) {
      final bytes = await pickedImg.readAsBytes();
      setState(() {
        _image = File(pickedImg.path);
        _binaryImg = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Trainers'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Trainer Name'),
                      validator: (value) => value!.isEmpty ? 'Enter trainer name' : null,
                    ),
                    TextFormField(
                      controller: _experienceController,
                      decoration: const InputDecoration(labelText: 'Experience'),
                      validator: (value) => value!.isEmpty ? 'Enter experience' : null,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) => value!.isEmpty ? 'Enter location' : null,
                    ),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                      validator: (value) => value!.isEmpty ? 'Enter category' : null,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: uploadImg,
                      child: _image != null
                          ? Image.file(_image!, height: 150, width: 150, fit: BoxFit.cover)
                          : Container(
                        height: 150,
                        width: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.add_a_photo, size: 50),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _saveTrainer,
                          child: Text(_docId == null ? 'Add Trainer' : 'Update Trainer'),
                        ),
                        if (_docId != null)
                          TextButton(
                            onPressed: _clearForm,
                            child: const Text('Cancel'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('TrainerList').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No trainers available.'));
                  }

                  final trainers = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: trainers.length,
                    itemBuilder: (context, index) {
                      final trainer = trainers[index];
                      final trainerData = trainer.data() as Map<String, dynamic>;

                      final img = trainerData['ImgUrl'];
                      Uint8List? decoded;

                      if (img != null && img.isNotEmpty) {
                        try {
                          decoded = base64Decode(img);
                        } catch (e) {
                          print("Error decoding image: $e");
                        }
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            foregroundImage: decoded != null ? MemoryImage(decoded) : null,
                          ),
                          title: Text(trainerData['Name'] ?? 'Unknown'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category: ${trainerData['Category'] ?? 'N/A'}'),
                              Text('Experience: ${trainerData['Experience'] ?? 'N/A'}'),
                              Text('Phone: ${trainerData['Phone'] ?? 'N/A'}'),
                              Text('Location: ${trainerData['Location'] ?? 'N/A'}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _nameController.text = trainerData['Name'] ?? '';
                                  _experienceController.text = trainerData['Experience'] ?? '';
                                  _phoneController.text = trainerData['Phone'] ?? '';
                                  _locationController.text = trainerData['Location'] ?? '';
                                  _categoryController.text = trainerData['Category'] ?? '';
                                  setState(() {
                                    _docId = trainer.id;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmDeleteTrainer(trainer.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
