import 'package:flutter/material.dart';
import 'ProfilePage.dart'; // Import ProfilePage

class SettingsPage extends StatelessWidget {
  final String selectedTheme;
  final bool isDarkMode;
  final ValueChanged<String> onThemeChanged;
  final VoidCallback onDarkModeChanged;

  const SettingsPage({
    super.key,
    required this.selectedTheme,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Personal Information Section
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(
                  isDarkMode: isDarkMode, // Add the missing parameter
                )),
              );
            },
            child: const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Personal Information'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          ),

          // Preferences Section
          const SectionTitle(title: 'Preferences'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Language Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Language:'),
                      DropdownButton<String>(
                        value: 'English',
                        onChanged: (value) {
                          // Add your language change logic here
                        },
                        items: ['English', 'Sinhala', 'Spanish', 'French']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Currency Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Currency:'),
                      DropdownButton<String>(
                        value: 'USD',
                        onChanged: (value) {
                          // Add your currency change logic here
                        },
                        items: ['USD', 'EUR', 'INR', 'LKR']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Dark Mode Toggle
                  SwitchListTile(
                    title: Text(isDarkMode ? 'Disable Dark Mode' : 'Enable Dark Mode'),
                    value: isDarkMode,
                    onChanged: (value) {
                      onDarkModeChanged(); // Toggle dark mode on click
                    },
                    secondary: const Icon(Icons.nightlight_round),
                  ),
                ],
              ),
            ),
          ),

          // Backup and Restore Section
          const SectionTitle(title: 'Backup and Restore'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cloud Options:'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: 'Google Backup',
                    onChanged: (value) {
                      // Add your backup logic here
                    },
                    items: ['Google Backup', 'Android Cloud']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                  const SizedBox(height: 16.0),
                  SwitchListTile(
                    title: const Text('Backup My Data'),
                    value: true,
                    onChanged: (value) {
                      // Add backup enable/disable logic
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Automatic Restore'),
                    value: false,
                    onChanged: (value) {
                      // Add restore logic
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}