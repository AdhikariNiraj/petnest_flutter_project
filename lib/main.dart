import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petnest_flutter_project/screens/admin/adoption%20list/adoption_list.dart';
import 'package:petnest_flutter_project/screens/admin/adoption%20list/confirm_adoption.dart';
import 'package:petnest_flutter_project/screens/dashboard_page.dart';
import 'package:petnest_flutter_project/screens/login_page.dart';
import 'package:petnest_flutter_project/screens/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      initialRoute: '/login', // Start with the login page
      routes: {
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/confirmAdoption': (context) {
          // Define the ConfirmAdoption route to accept arguments
          final adoptionRequestId = ModalRoute.of(context)!.settings.arguments as String;
          return ConfirmAdoption(adoptionRequestId: adoptionRequestId);
        },
        '/confirmedRejectedList': (context) => const ConfirmedRejectedList(),
      },
    );
  }
}
