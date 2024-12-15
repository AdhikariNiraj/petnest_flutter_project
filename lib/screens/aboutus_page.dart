import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blueAccent, // Set a more vibrant app bar color
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              const Text(
                'Welcome to PetNest',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'At PetNest, we are dedicated to connecting loving families with their perfect pet companions. Our mission is to make pet adoption seamless and enjoyable while ensuring every pet finds a caring home.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32.0),

              // What We Do section with Card widget for emphasis
              const Text(
                'What We Do:',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.pets, color: Colors.blue),
                        title: Text(
                          'Partner with breeders, shops, and pet sellers to showcase pets available for adoption.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.search, color: Colors.blue),
                        title: Text(
                          'Provide an easy-to-use platform for browsing and selecting pets.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.link, color: Colors.blue),
                        title: Text(
                          'Act as a bridge between adopters and pet providers while ensuring quality and trust.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.school, color: Colors.blue),
                        title: Text(
                          'Provide a list of professional trainers for training pets and owners.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),

              // Our Values section with icon-based styling
              const Text(
                'Our Values:',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.favorite, color: Colors.pink),
                        title: Text(
                          'Compassion: Every pet deserves a loving home.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.security, color: Colors.green),
                        title: Text(
                          'Integrity: We are committed to transparency and ethical practices.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.people, color: Colors.orange),
                        title: Text(
                          'Community: Building a network of pet lovers and responsible owners.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),

              // Contact Us section with button
              const Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.blue),
                        title: Text(
                          'Email: support@petnest.com',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.blue),
                        title: Text(
                          'Phone: +977 9807064676',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.blue),
                        title: Text(
                          'Address: Kupondole, Lalitpur',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),

              // Back to Home Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}