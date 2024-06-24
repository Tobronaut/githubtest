// home_page.dart
import 'package:flutter/material.dart';
import 'listen_page.dart';
import 'vokabeln_page.dart';

class HomePage extends StatefulWidget {
  final bool isDarkModeEnabled;
  final ValueChanged<bool> onDarkModeToggle;

  HomePage({required this.isDarkModeEnabled, required this.onDarkModeToggle});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 145, 207),
        title: const Text(
          'LexiList',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white),
            onSelected: (String value) {},
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'darkMode',
                child: ListTile(
                  leading: Icon(Icons.dark_mode,
                      color: widget.isDarkModeEnabled
                          ? Colors.white
                          : Colors.black),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                        color: widget.isDarkModeEnabled
                            ? Colors.white
                            : Colors.black),
                  ),
                  trailing: Switch(
                    value: widget.isDarkModeEnabled,
                    onChanged: (value) {
                      Navigator.pop(context);
                      widget.onDarkModeToggle(value);
                    },
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onDarkModeToggle(!widget.isDarkModeEnabled);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListenPage(
                          isDarkModeEnabled: widget.isDarkModeEnabled)),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 50),
                backgroundColor: const Color.fromARGB(255, 21, 145, 207),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list, size: 40),
                  SizedBox(width: 20),
                  Text(
                    'Listen',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Vokabeln()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 137, vertical: 50),
                backgroundColor: const Color.fromARGB(255, 21, 145, 207),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 40),
                  SizedBox(width: 10),
                  Text(
                    'Vokabeln',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
