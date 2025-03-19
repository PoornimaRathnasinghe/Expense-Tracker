import 'package:flutter/material.dart';
import '../screens/Insights.dart';
import '../screens/settings.dart';
import '../screens/Home.dart';
import '../screens/add_transaction.dart';
import '../screens/ProfilePage.dart';
import '../screens/transaction.dart';

class NavigationScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onDarkModeChanged;
  final String? initialTheme;

  const NavigationScreen({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    this.initialTheme, required Null Function(dynamic theme) onThemeChanged,
  });

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() {
        _isDarkMode = widget.isDarkMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // List of pages for navigation
    final List<Widget> pages = [
      HomePage(isDarkMode: _isDarkMode),
      AddTransactionPage(isDarkMode: _isDarkMode),
      TransactionsPage(isDarkMode: _isDarkMode),
      InsightsScreen(isDarkMode: _isDarkMode),
      ProfilePage(isDarkMode: _isDarkMode),
      SettingsPage(
        isDarkMode: _isDarkMode,
        selectedTheme: widget.initialTheme ?? (_isDarkMode ? 'Dark' : 'Light'),
        onThemeChanged: (theme) {
          // This will be handled by the parent widget
        },
        onDarkModeChanged: widget.onDarkModeChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_outlined),
            activeIcon: Icon(Icons.add_chart),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_outlined),
            activeIcon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}