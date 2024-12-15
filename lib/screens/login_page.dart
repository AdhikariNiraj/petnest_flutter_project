import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../common/toast.dart';
import '../widgets/form_widgets.dart';
import 'admin/admin_dashboard.dart';
import 'dashboard_page.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart'; // Import ForgotPasswordPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // FirebaseAuth instance to handle authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Controllers for email and password input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Boolean to track signing-in state
  bool _isSigning = false;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevent overflow when keyboard appears
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back button
        title: const Text("Login"), // Title of the page
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login title
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30), // Spacing

                // Email input field
                FormContainerWidget(
                  controller: _emailController,
                  hintText: "Email",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10), // Spacing

                // Password input field
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                const SizedBox(height: 8), // Adjusted Spacing

                // "Forgot Password" button aligned to the right
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the ForgotPasswordPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Spacing

                // Login button
                GestureDetector(
                  onTap: _signIn, // Call _signIn method
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _isSigning
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Spacing

                // Sign-up prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the SignUpPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to handle user login
  void _signIn() async {
    setState(() {
      _isSigning = true; // Show loading indicator
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Handle Admin Login
      if (email == 'nirajadhikari513@gmail.com' && password == 'niraj123') {
        showToast(message: "Admin successfully logged in");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
        return;
      }

      // Handle User Login
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        // Reload user to ensure updated email verification status
        await user.reload();
        final refreshedUser = _firebaseAuth.currentUser;

        if (refreshedUser == null || !refreshedUser.emailVerified) {
          // If email is not verified or refreshedUser is null, prompt the user
          await _firebaseAuth.signOut();
          showToast(message: "Please verify your email before logging in.");
        } else {
          // Update Firestore to reflect email verification status
          await FirebaseFirestore.instance
              .collection('users')
              .doc(refreshedUser.uid) // Safe access to uid
              .update({"isEmailVerified": true});

          // Navigate to the user dashboard
          showToast(message: "User successfully logged in");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(message: "No user found for this email.");
      } else if (e.code == 'wrong-password') {
        showToast(message: "Incorrect password.");
      } else {
        showToast(message: "Error: ${e.message}");
      }
    } finally {
      setState(() {
        _isSigning = false; // Hide loading indicator
      });
    }
  }
}
