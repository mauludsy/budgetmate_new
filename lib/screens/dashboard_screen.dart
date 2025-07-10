import 'package:flutter/material.dart';
import 'package:budget_mate_app/screens/graph_screen.dart';
import 'package:budget_mate_app/services/api_service.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  double totalPengeluaran = 0;
  double totalPemasukan = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final transactions = await ApiService.getTransactions();
      double pengeluaran = 0;
      double pemasukan = 0;

      for (var tx in transactions) {
        final amount = double.tryParse(tx['amount'].toString()) ?? 0;
        if (tx['type'] == 'expense') {
          pengeluaran += amount;
        } else if (tx['type'] == 'income') {
          pemasukan += amount;
        }
      }

      setState(() {
        totalPengeluaran = pengeluaran;
        totalPemasukan = pemasukan;
      });
    } catch (e) {
      print('❌ Error fetching dashboard summary: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 3,
            child: ListTile(
              title: const Text("Total Pemasukan", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(formatter.format(totalPemasukan)),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            child: ListTile(
              title: const Text("Total Pengeluaran", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(formatter.format(totalPengeluaran)),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Grafik Pengeluaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const GraphScreen(), // grafik pie ditampilkan di dashboard
        ],
      ),
    );
  }
}
