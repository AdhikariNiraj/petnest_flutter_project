import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<UserListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  List<Map<String, dynamic>> users = []; // List to store users fetched from Firestore
  List<Map<String, dynamic>> filteredUsers = []; // List to store filtered users based on search
  bool isLoading = true; // Flag to show a loading indicator while data is being fetched
  final TextEditingController _searchController = TextEditingController(); // Controller for search bar

  @override
  void initState() {
    super.initState();
    _fetchAllUsers(); // Fetch all users when the widget is initialized
  }

  // Function to fetch all users from Firestore
  Future<void> _fetchAllUsers() async {
    try {
      // Fetch all users from the Firestore "users" collection
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection("users").get();

      // Print how many documents are fetched for debugging
      print("Fetched users count: ${snapshot.docs.length}");

      // Map the fetched documents to a list of user data
      setState(() {
        users = snapshot.docs.map((doc) => doc.data()).toList();
        filteredUsers = users; // Initialize filtered users with all users
      });
    } catch (e) {
      // If there is an error during fetching, show an empty list and print the error
      setState(() {
        users = [];
        filteredUsers = [];
      });
      print("Error fetching users: $e");
    } finally {
      // Stop showing loading spinner after data is fetched
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle the search operation
  void _searchUser(String query) {
    final filtered = users.where((user) {
      // Convert both the user name and email to lowercase for case-insensitive search
      final name = user["name"] ?? "";
      final email = user["email"] ?? "";
      return name.toLowerCase().contains(query.toLowerCase()) || // Check if the user's name contains the search query
          email.toLowerCase().contains(query.toLowerCase()); // Check if the user's email contains the search query
    }).toList();

    setState(() {
      filteredUsers = filtered; // Update the filtered users list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin - Users List"), // AppBar with a title
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController, // Link the search field to the controller
              onChanged: _searchUser, // Trigger the search when the text changes
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search), // Search icon inside the text field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner if data is still being fetched
          : filteredUsers.isEmpty
          ? const Center(child: Text("No active users found")) // Display message if no users are found
          : _buildUserList(), // If there are users, call _buildUserList to display them
    );
  }

  // Function to build the list view of users
  Widget _buildUserList() {
    return ListView.builder(
      itemCount: filteredUsers.length, // Number of users to display (filtered list)
      itemBuilder: (context, index) {
        final user = filteredUsers[index]; // Get the user data at the current index
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0), // Add margin for each card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for the card
          ),
          elevation: 5, // Add elevation to create a shadow effect
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue, // Avatar background color
              child: Text(
                (user["name"] ?? "N/A")[0].toUpperCase(), // Display the first letter of the user's name
                style: const TextStyle(color: Colors.white), // Set the text color to white
              ),
            ),
            title: Text(user["name"] ?? "N/A"), // Display the user's name
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user["email"] ?? "No Email"), // Display the user's email
                Text(user["phone"] ?? "No Phone"), // Display the user's phone
                Text(user["address"] ?? "No Address"), // Display the user's address
                Text(user["createdAt"] != null
                    ? (user["createdAt"] as Timestamp).toDate().toString() // Display the user's creation date
                    : "No Creation Date"),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.info), // Info icon on the right
              onPressed: () {
                // Handle the action when clicking the info icon (e.g., view more details)
              },
            ),
          ),
        );
      },
    );
  }
}
