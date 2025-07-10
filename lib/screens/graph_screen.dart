import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final oCcy = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  Map<String, double> categoryTotals = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    try {
      final transactions = await ApiService.getTransactions();
      final Map<String, double> totals = {};

      for (var tx in transactions) {
        if (tx['type'] != 'expense') continue;

        final category = tx['category'] ?? 'Lain-lain';
        final amount = double.tryParse(tx['amount'].toString()) ?? 0.0;

        totals[category] = (totals[category] ?? 0.0) + amount;
      }

      setState(() {
        categoryTotals = totals;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Gagal ambil transaksi: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final double totalPengeluaran = categoryTotals.values.fold(0.0, (a, b) => a + b);

    final List<Map<String, dynamic>> pieData = categoryTotals.entries.map((entry) {
      final category = dummyCategories.firstWhere(
        (c) => c.name == entry.key,
        orElse: () => dummyCategories.last,
      );
      final percentage = totalPengeluaran > 0 ? (entry.value / totalPengeluaran) * 100 : 0;

      return {
        'name': entry.key,
        'percentage': percentage,
        'icon': category.icon,
        'color': category.color,
      };
    }).where((data) => (data['percentage'] as num).toDouble() > 0).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ringkasan Kategori Pengeluaran',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (pieData.isEmpty)
              const Center(
                child: Text(
                  'Belum ada data pengeluaran',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: pieData.map((data) {
                          return PieChartSectionData(
                            color: data['color'] as Color,
                            value: (data['percentage'] as num).toDouble(),
                            title: '${(data['percentage'] as num).toDouble().toStringAsFixed(1)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: pieData.map((data) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(data['icon'] as IconData, color: data['color'] as Color, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(data['name'], style: const TextStyle(fontSize: 16)),
                              ),
                              Text(
                                '${(data['percentage'] as num).toDouble().toStringAsFixed(1)}%',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 30),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var entry in categoryTotals.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key, style: const TextStyle(fontSize: 16)),
                            Text(oCcy.format(entry.value),
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pengeluaran',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(oCcy.format(totalPengeluaran),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
