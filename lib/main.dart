import 'package:flutter/material.dart';
import 'package:budget_mate_app/screens/auth_screen.dart';
import 'package:budget_mate_app/screens/dashboard_screen.dart'; // pastikan file ini ada

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Mate',
      theme: ThemeData(
        primaryColor: const Color(0xFF8BC34A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8BC34A),
          primary: const Color(0xFF8BC34A),
          secondary: const Color(0xFFCDDC39),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8BC34A),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF8BC34A),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
