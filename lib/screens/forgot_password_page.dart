import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../common/toast.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;

    void sendPasswordReset() async {
      final email = emailController.text.trim();

      if (email.isEmpty) {
        showToast(message: "Please enter your email.");
        return;
      }

      try {
        await auth.sendPasswordResetEmail(email: email);
        showToast(message: "Password reset email sent.");
        Navigator.pop(context);
      } catch (e) {
        showToast(message: "Error: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter your email address to receive a password reset link.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendPasswordReset,
              child: const Text("Send Reset Link"),
            ),
          ],
        ),
      ),
    );
  }
}
