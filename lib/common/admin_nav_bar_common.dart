import 'package:flutter/material.dart';
import 'package:petnest_flutter_project/screens/admin/admin_dashboard.dart';
import 'package:petnest_flutter_project/screens/admin/admin_trainer_list_page.dart';
import 'package:petnest_flutter_project/screens/admin/Admin_view_list_all_user_page.dart';
import '../screens/aboutus_page.dart';
import '../screens/admin/adoption list/adoption_list.dart';
import '../screens/admin/dog_add_page.dart';
import '../screens/login_page.dart';


class AdminBasePage extends StatefulWidget {
  final Widget bodyContent; // This will hold the custom content of the page
  final String title; // Added title parameter to accept a dynamic title


// Initialize both the bodyContent and title in the constructor
  const AdminBasePage({super.key, required this.bodyContent, required this.title});

  @override
  BasePageState createState() => BasePageState(); // Update to use BasePageState without the underscore
}

class BasePageState extends State<AdminBasePage> {
  int _selectedIndex = 0; // Track selected tab index

  // Logout Functionality
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle BottomNavigationBar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()), // Navigate to HomePage
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConfirmedRejectedList()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddDogPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Dashboard'),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminDashboard()), // Navigate to HomePage
                );
              },
            ),

            // trainer list page
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Trainer list'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminTrainerAddPage()),
                );
              },
            ),

            //Add Dog
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Add Dog'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddDogPage()),
                );
              },
            ),


            //confirm adoption
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Confirm Adoption'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfirmedRejectedList()),
                );
              },
            ),

            //user list
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserListPage()),
                );
              },
            ),


            //AboutUs page
            ListTile(
              leading: const Icon(Icons.account_box_rounded),
              title: const Text('AboutUs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),

            //Favourite
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favourite'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Feature Unavailable'),
                    content: const Text('Favourite page are not yet implemented.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),



            //notification
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Feature Unavailable'),
                    content: const Text('Notifications are not yet implemented.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),



            // Share
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Feature Unavailable'),
                    content: const Text('Share page are not yet implemented.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),





            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: widget.bodyContent, // Use the body content passed to the BasePage
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Keep track of the selected index
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Confirm Adoption'),
          BottomNavigationBarItem(icon: Icon(Icons.pets_outlined), label: 'Add Dog'),
        ],
        onTap: _onItemTapped, // Handle tab item tap
      ),
    );
  }
}
