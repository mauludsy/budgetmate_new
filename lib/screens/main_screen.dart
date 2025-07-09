// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:budget_mate_app/screens/dashboard_screen.dart';
import 'package:budget_mate_app/screens/graph_screen.dart';
import 'package:budget_mate_app/screens/transaction_in_out_screen.dart';
import 'package:budget_mate_app/screens/split_bill_screen.dart';
import 'package:budget_mate_app/screens/account_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = const [
    DashboardScreen(),
    GraphScreen(),
    TransactionInOutScreen(),
    SplitBillScreen(),
    AccountScreen(),
  ];

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
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Grafik'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: 'Tambah'),
          BottomNavigationBarItem(
              icon: Icon(Icons.call_split), label: 'Split Bill'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Akun'),
        ],
      ),
    );
  }
}
