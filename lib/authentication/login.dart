import 'package:expense_tracker/authentication/forgot.dart';
import 'package:expense_tracker/authentication/signup.dart';
import 'package:expense_tracker/authentication/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  signIn() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: password.text);
    await _saveUserDetails(userCredential.user);
    Get.offAll(const Wrapper());
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    await _saveUserDetails(userCredential.user);
    Get.offAll(const Wrapper());
    return userCredential;
  }

  Future<void> _saveUserDetails(User? user) async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', user.displayName ?? '');
      await prefs.setString('email', user.email ?? '');
      await prefs.setString('photoURL', user.photoURL ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
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
                'Welcome to Expense Tracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please login to continue',
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
              TextField(
                controller: password,
                decoration: const InputDecoration(
                  hintText: 'Enter password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (() => signIn()),
                style: ElevatedButton.styleFrom(
               
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Login"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (() => Get.to(const Signup())),
                style: ElevatedButton.styleFrom(
                  
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Register now!"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (() => Get.to(const Forgot())),
                style: ElevatedButton.styleFrom(
                
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Forgot password?"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await signInWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Sign in with Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}