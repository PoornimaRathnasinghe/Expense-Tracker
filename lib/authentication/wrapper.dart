import 'package:expense_tracker/Shared/Navigation.dart'; // Import NavigationScreen
import 'package:expense_tracker/authentication/login.dart';
import 'package:expense_tracker/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NavigationScreen(
              isDarkMode: themeProvider.isDarkMode,
              onDarkModeChanged: () {
                themeProvider.toggleTheme();
              }, onThemeChanged: (theme) {  },
            );
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
