import 'package:flutter/material.dart';
import 'src/presentation/screens/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.green,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.green,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.green,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}
