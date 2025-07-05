// lib/screens/graph_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  // Contoh data dummy untuk grafik pengeluaran dan pemasukan
  final List<FlSpot> _pengeluaranSpots = const [
    FlSpot(0, 3.2), // Jan
    FlSpot(1, 2.5), // Feb
    FlSpot(2, 5.0), // Mar
    FlSpot(3, 4.0), // Apr
    FlSpot(4, 3.8), // Mei
    FlSpot(5, 6.5), // Jun
    FlSpot(6, 4.7), // Jul
  ];

  final List<FlSpot> _pemasukanSpots = const [
    FlSpot(0, 4.0), // Jan
    FlSpot(1, 3.5), // Feb
    FlSpot(2, 6.0), // Mar
    FlSpot(3, 4.5), // Apr
    FlSpot(4, 5.0), // Mei
    FlSpot(5, 7.0), // Jun
    FlSpot(6, 5.5), // Jul
  ];

  final oCcy = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Grafik Pengeluaran & Pemasukan Bulanan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              height: 300, // Tinggi grafik
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
                          Widget text;
                          switch (value.toInt()) {
                            case 0: text = const Text('Jan', style: style); break;
                            case 1: text = const Text('Feb', style: style); break;
                            case 2: text = const Text('Mar', style: style); break;
                            case 3: text = const Text('Apr', style: style); break;
                            case 4: text = const Text('Mei', style: style); break;
                            case 5: text = const Text('Jun', style: style); break;
                            case 6: text = const Text('Jul', style: style); break;
                            default: text = const Text('', style: style); break;
                          }
                          return SideTitleWidget(axisSide: meta.axisSide, child: text);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
                          String text;
                          if (value == 0) {
                            text = '0';
                          } else if (value == 2) {
                            text = '2jt';
                          } else if (value == 4) {
                            text = '4jt';
                          } else if (value == 6) {
                            text = '6jt';
                          } else {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 7, // Sesuaikan dengan nilai Y maksimum data Anda
                  lineBarsData: [
                    // Data Pengeluaran
                    LineChartBarData(
                      spots: _pengeluaranSpots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.redAccent, Colors.red[800]!],
                      ),
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Data Pemasukan
                    LineChartBarData(
                      spots: _pemasukanSpots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.greenAccent, Colors.green[800]!],
                      ),
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Legenda
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 20, height: 8, color: Colors.redAccent),
                const SizedBox(width: 5),
                const Text('Pengeluaran'),
                const SizedBox(width: 20),
                Container(width: 20, height: 8, color: Colors.greenAccent),
                const SizedBox(width: 5),
                const Text('Pemasukan'),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Detail Analisis:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Anda bisa tambahkan ListView untuk daftar transaksi atau ringkasan lain
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Pengeluaran Bulan Ini: ${oCcy.format(6500000)}'),
                    Text('Total Pemasukan Bulan Ini: ${oCcy.format(7200000)}'),
                    const Divider(),
                    Text('Saldo Bersih: ${oCcy.format(700000)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}