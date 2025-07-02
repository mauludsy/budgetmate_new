// lib/main.dart

import 'package:flutter/material.dart';
import 'package:budget_mate_app/screens/dashboard_screen.dart'; // Import halaman dashboard baru kita

void main() {
  runApp(const MyApp()); // Jalankan aplikasi Flutter
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetMate', // Judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.green, // Menggunakan warna hijau sebagai warna utama tema
        primaryColor: Colors.green.shade700, // Warna primer yang lebih spesifik
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700, // Warna latar belakang AppBar
          foregroundColor: Colors.white, // Warna teks dan ikon di AppBar
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green.shade600, // Warna latar belakang Floating Action Button
          foregroundColor: Colors.white, // Warna ikon/teks di FAB
        ),
        cardTheme: CardThemeData( // Menggunakan CardThemeData untuk tema kartu
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Sudut membulat untuk semua Card
          ),
        ),
        useMaterial3: true, // Mengaktifkan Material Design 3
      ),
      home: const DashboardScreen(), // Halaman awal yang akan ditampilkan adalah DashboardScreen
      debugShowCheckedModeBanner: false, // Sembunyikan banner "DEBUG"
    );
  }
}
