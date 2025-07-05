// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:budget_mate_app/screens/dashboard_screen.dart';
import 'package:budget_mate_app/screens/graph_screen.dart';
import 'package:budget_mate_app/screens/transaction_in_out_screen.dart';
import 'package:budget_mate_app/screens/split_bill_screen.dart';
import 'package:budget_mate_app/screens/account_screen.dart';
import 'package:budget_mate_app/screens/auth_screen.dart'; // Import AuthScreen Anda

// void main() {
//   runApp(const MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // WAJIB sebelum async operation
  await initializeDateFormatting('id', null); // Inisialisasi format lokal Indonesia
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false; // Status login pengguna

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Panggil fungsi untuk cek status login saat aplikasi dimulai
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Untuk pengembangan/debugging, Anda bisa mengaktifkan baris di bawah ini untuk mereset status login
    // Ini akan memaksa aplikasi selalu ke AuthScreen saat restart
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Ambil status login, default false
      print('Status login saat ini: $_isLoggedIn'); // Debugging
    });
  }

  // Fungsi untuk update status login dari AuthScreen setelah berhasil login
  void _updateLoginStatus(bool status) {
    setState(() {
      _isLoggedIn = status;
      print('Status login diperbarui menjadi: $_isLoggedIn'); // Debugging
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Mate App', // Sesuai dengan nama proyek Anda
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Navigasi kondisional berdasarkan status login
      home: _isLoggedIn
          ? const MainScreen() // Jika sudah login, langsung ke MainScreen
          : AuthScreen(
              onLoginSuccess: () {
                _updateLoginStatus(true); // Panggil ini saat login berhasil
              },
            ), // Jika belum login, ke AuthScreen
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const DashboardScreen(),
      const GraphScreen(),
      const TransactionInOutScreen(),
      const SplitBillScreen(),
      const AccountScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Keuangan'),
        backgroundColor: Colors.lightGreen,
        elevation: 0,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Grafik'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Tambah'),
          BottomNavigationBarItem(icon: Icon(Icons.call_split), label: 'Split Bill'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Akun'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }
}