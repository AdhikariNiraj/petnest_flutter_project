import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  Map<String, dynamic>? userData; // Variable to store user data
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the widget is initialized
  }

  // Function to fetch user data
  Future<void> _fetchUserData() async {
    try {
      // Get the currently logged-in user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Use the UID to fetch data from Firestore
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
            .collection("users")
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          // Save the data into the `userData` variable
          setState(() {
            userData = userDoc.data();
          });
        } else {
          // Handle case where user data is not found in Firestore
          setState(() {
            userData = {"error": "User data not found in Firestore!"};
          });
        }
      } else {
        // Handle case where no user is logged in
        setState(() {
          userData = {"error": "No user is logged in!"};
        });
      }
    } catch (e) {
      // Handle any errors that occur while fetching data
      setState(() {
        userData = {"error": "An error occurred: $e"};
      });
    } finally {
      // Stop the loading spinner
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        actions: [
          IconButton(
            onPressed: _logout, // Logout function
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : userData == null
          ? const Center(child: Text("No data found")) // Handle case where no data is found
          : userData!["error"] != null
          ? Center(child: Text(userData!["error"])) // Show error message if any
          : _buildProfileLayout(),
    );
  }

  // Widget to display profile layout
  Widget _buildProfileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                (userData!["name"] ?? "N/A")[0].toUpperCase(),
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow("Name", userData!["name"]),
          const Divider(),
          _buildInfoRow("Email", userData!["email"]),
          const Divider(),
          _buildInfoRow("Phone", userData!["phone"]),
          const Divider(),
          _buildInfoRow("Address", userData!["address"]),
          const Divider(),
          _buildInfoRow(
            "Account Created",
            _formatDate(userData!["createdAt"] as Timestamp),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // Widget to display information rows
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
              value ?? "N/A",
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Function to format the date
  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(date); // Format as YYYY-MM-DD
  }

  // Function to log out the user
  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, "/login"); // Redirect to login page
  }
}
