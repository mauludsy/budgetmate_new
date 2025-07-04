import 'package:flutter/material.dart';
import 'package:budget_mate_app/screens/auth_screen.dart';

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
        // ========================================================
        // Baris-baris ini dinonaktifkan sementara untuk mengatasi error CardTheme
        // cardTheme: const CardTheme(
        //   elevation: 4,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
        //   ),
        // ),
        // ========================================================
        useMaterial3: true,
      ),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}