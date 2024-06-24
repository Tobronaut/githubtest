// main.dart
import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = prefs.getBool('darkMode') ?? false;
    });
  }

  void _toggleDarkMode(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = isEnabled;
      prefs.setBool('darkMode', isEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(
        isDarkModeEnabled: _isDarkModeEnabled,
        onDarkModeToggle: _toggleDarkMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
