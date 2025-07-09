import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:budget_mate_app/screens/dashboard_screen.dart';
import 'package:budget_mate_app/screens/graph_screen.dart';
import 'package:budget_mate_app/screens/transaction_in_out_screen.dart';
import 'package:budget_mate_app/screens/split_bill_screen.dart';
import 'package:budget_mate_app/screens/account_screen.dart';
import 'package:budget_mate_app/screens/auth_screen.dart';
import 'package:budget_mate_app/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ DEBUG ONLY: Reset status login untuk memastikan layar login muncul.
    // ❗️ HAPUS baris ini setelah login muncul dan bekerja normal.
    await prefs.remove('isLoggedIn');

    // Ambil status login dari SharedPreferences
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('🟡 Status login saat ini: $_isLoggedIn');

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Budget Mate App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: _isLoggedIn ? const MainScreen() : const AuthScreen(),
    );
  }
}
