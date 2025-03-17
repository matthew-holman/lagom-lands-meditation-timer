import 'package:flutter/material.dart';
import 'pages/timer_page.dart';
import 'pages/settings_page.dart';
import 'pages/info_page.dart';

class MeditationApp extends StatelessWidget {
  const MeditationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindful Timer',
      theme: ThemeData(
        primarySwatch: Colors.yellow, // Set the main theme color to yellow
        scaffoldBackgroundColor: Colors.yellow, // Light yellow background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.yellow, // Yellow app bars
          foregroundColor: Colors.black, // Dark text for contrast
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.yellow, // Yellow bottom navigation bar
          selectedItemColor: Colors.grey, // Highlighted item in black
          elevation: 0, // Remove shadow
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _selectedPage = "Timer";

  static final Map<String, Widget> _pages = {
    "Timer": const TimerPage(),
    "Settings": const SettingsPage(),
    "Info": const InfoPage(),
  };

  static final Map<String, BottomNavigationBarItem> _allItems = {
    "Timer": const BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Timer"),
    "Settings": const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
    "Info": const BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
  };

  void _onItemTapped(String newPage) {
    setState(() {
      _selectedPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter out the current page from the navigation bar
    List<MapEntry<String, BottomNavigationBarItem>> filteredItems = _allItems.entries
        .where((entry) => entry.key != _selectedPage)
        .toList();

    return Scaffold(
      body: _pages[_selectedPage]!,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Always show the first available item as selected
        onTap: (index) => _onItemTapped(filteredItems[index].key),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: filteredItems.map((entry) => entry.value).toList(),
      ),
    );
  }
}