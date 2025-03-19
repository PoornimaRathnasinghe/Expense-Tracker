import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController email = TextEditingController();
  bool linkSent = false; // Track if the link has been sent

  reset() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
    setState(() {
      linkSent = true; // Update the state to show the message
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Reset your password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter your email to receive a password reset link',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  hintText: 'Enter email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (() => reset()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Send link"),
              ),
              const SizedBox(height: 20),
              if (linkSent) // Show the message if the link has been sent
                const Text(
                  'A password reset link has been sent to your email.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}