import 'package:flutter/material.dart';
import 'adoption widget/category_screens/dog_page.dart';

class AdoptPet extends StatefulWidget {
  const AdoptPet({super.key});

  @override
  State<AdoptPet> createState() => _AdoptPetState();
}

class _AdoptPetState extends State<AdoptPet> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Remove the AppBar entirely
      body: DogPage(), // Directly display DogPage
    );
  }
}
