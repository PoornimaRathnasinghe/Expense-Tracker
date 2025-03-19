import 'package:shared_preferences/shared_preferences.dart';

// Save theme preference
void saveThemePreference(bool isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDarkMode', isDarkMode);
}

// Load theme preference
Future<bool> loadThemePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDarkMode') ?? false; // Default to false (light theme)
}
