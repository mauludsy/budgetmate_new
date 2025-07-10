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

  final GlobalKey<DashboardScreenState> _dashboardKey = GlobalKey();

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      DashboardScreen(key: _dashboardKey),
      const GraphScreen(),
      const Placeholder(), // Placeholder untuk tab Tambah (tidak digunakan langsung)
      const SplitBillScreen(),
      const AccountScreen(),
    ];
  }

  void _onItemTapped(int index) async {
    if (index == 2) {
      // Navigasi ke layar tambah transaksi
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TransactionInOutScreen()),
      );

      if (result == true) {
        // Setelah tambah transaksi berhasil, kembali ke dashboard
        setState(() {
          _selectedIndex = 0;
        });
        _dashboardKey.currentState?.fetchDashboardData();
      }

      return; // jangan lanjut ke setState _selectedIndex = 2
    }

    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        _dashboardKey.currentState?.fetchDashboardData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Grafik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_split),
            label: 'Split Bill',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
