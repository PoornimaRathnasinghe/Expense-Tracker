import 'package:expense_tracker/authentication/wrapper.dart';
import 'package:expense_tracker/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'Shared/Navigation.dart';
import 'firebase_options.dart';
import 'screens/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState(); // Fixed to use State<MyApp>
}

class _MyAppState extends State<MyApp> {
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeProvider.setTheme(isDarkMode ? ThemeData.dark() : ThemeData.light());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => GetMaterialApp(
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.getTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => const Wrapper(),
            '/home': (context) => NavigationScreen(
              initialTheme: themeProvider.isDarkMode ? 'Dark' : 'Light',
              isDarkMode: themeProvider.isDarkMode, // Add the missing parameter
              onThemeChanged: (theme) {
                final isDark = theme == 'Dark';
                themeProvider.setTheme(isDark ? ThemeData.dark() : ThemeData.light());
                _savePreferences(isDark);
              },
              onDarkModeChanged: () { // Changed to VoidCallback
                final newMode = !themeProvider.isDarkMode;
                themeProvider.setTheme(newMode ? ThemeData.dark() : ThemeData.light());
                _savePreferences(newMode);
              },
            ),
            '/transactions': (context) => TransactionsPage(
              isDarkMode: themeProvider.isDarkMode, // Add the missing parameter
            ),
          },
        ),
      ),
    );
  }

  void _savePreferences(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}