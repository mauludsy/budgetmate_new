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
  // Data dummy pengeluaran harian untuk satu bulan (misal Juni)
  final List<double> _pengeluaranHarian = const [
    50000, 20000, 0, 0, 15000, 0, 70000, // Hari 1-7
    45000, 30000, 0, 0, 120000, 40000, 20000, // Hari 8-14
    0, 0, 80000, 30000, 0, 0, 0, // Hari 15-21
    10000, 25000, 60000, 0, 0, 90000, 75000, 10000 // Hari 22-30
  ];

  // Data dummy untuk Peringkat Kategori
  // 'Lain-lain' dipindahkan ke posisi paling bawah
  final List<Map<String, dynamic>> _categoryData = [
    {'name': 'Belanja', 'percentage': 39.6, 'color': Colors.pink, 'icon': Icons.shopping_bag},
    {'name': 'Hiburan', 'percentage': 16.3, 'color': Colors.red, 'icon': Icons.movie},
    {'name': 'Makan', 'percentage': 8.7, 'color': Colors.orange, 'icon': Icons.fastfood},
    {'name': 'Transportasi', 'percentage': 7.5, 'color': Colors.blue, 'icon': Icons.directions_car},
    {'name': 'Tagihan', 'percentage': 5.0, 'color': Colors.purple, 'icon': Icons.receipt},
    {'name': 'Kesehatan', 'percentage': 4.6, 'color': Colors.cyan, 'icon': Icons.local_hospital},
    {'name': 'Lain-lain', 'percentage': 18.3, 'color': Colors.grey, 'icon': Icons.more_horiz}, // Dipindah ke paling bawah
  ];

  final oCcy = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);


  @override
  Widget build(BuildContext context) {
    // Hitung total pengeluaran bulan ini dari data harian
    final double totalPengeluaranBulanIni = _pengeluaranHarian.reduce((a, b) => a + b);
    // Asumsi pemasukan bulan ini tetap dummy, karena grafik ini fokus pengeluaran harian
    final double totalPemasukanBulanIniDummy = 7200000.0;
    final double saldoBersihDummy = totalPemasukanBulanIniDummy - totalPengeluaranBulanIni;

    // Nilai Y maksimum untuk grafik harian, diatur ke 3 juta
    const double fixedMaxY = 3000000.0; // <<< DIATUR KE 3 JUTA


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Grafik Pengeluaran Bulanan (Juni)',
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
                        interval: 5, // Tampilkan label setiap 5 hari
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text('${value.toInt()}', style: style), // Menampilkan tanggal
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        // Interval disesuaikan untuk rentang 0-3jt
                        interval: 1000000, // Interval 1 juta
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
                          String text;
                          if (value == 0) {
                            text = '0';
                          } else if (value == 1000000) { // 1 juta
                            text = '1jt';
                          } else if (value == 2000000) { // 2 juta
                            text = '2jt';
                          } else if (value == 3000000) { // 3 juta
                            text = '3jt';
                          } else {
                            return const SizedBox.shrink(); // Sembunyikan label lain
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
                  minX: 1, // Mulai dari hari ke-1
                  maxX: _pengeluaranHarian.length.toDouble(), // Sampai hari terakhir
                  minY: 0,
                  maxY: fixedMaxY, // <<< MENGGUNAKAN NILAI Y MAKSIMUM TETAP 3 JUTA
                  lineBarsData: [
                    // Data Pengeluaran Harian
                    LineChartBarData(
                      spots: List.generate(_pengeluaranHarian.length, (index) {
                        return FlSpot(index + 1.0, _pengeluaranHarian[index]); // X = hari, Y = nominal
                      }),
                      isCurved: true,
                      color: Colors.deepPurple, // Warna garis
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.deepPurple.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Keterangan Sumbu
            const Text(
              'Sumbu X: Tanggal Harian\nSumbu Y: Jumlah Pengeluaran',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Detail Analisis
            const Text(
              'Ringkasan Bulan Ini:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Pengeluaran Bulan Ini: ${oCcy.format(totalPengeluaranBulanIni)}'),
                    Text('Total Pemasukan Bulan Ini: ${oCcy.format(totalPemasukanBulanIniDummy)}'),
                    const Divider(),
                    Text('Saldo Bersih: ${oCcy.format(saldoBersihDummy)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Bagian Peringkat Kategori
            const Text(
              'Peringkat Kategori',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grafik Pie (Lingkaran) di kiri
                SizedBox(
                  width: 150, // Lebar grafik pie
                  height: 150, // Tinggi grafik pie
                  child: PieChart(
                    PieChartData(
                      sections: _categoryData.map((data) {
                        return PieChartSectionData(
                          color: data['color'] as Color,
                          value: data['percentage'] as double,
                          title: '${data['percentage'].toStringAsFixed(1)}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                          ),
                        );
                      }).toList(),
                      sectionsSpace: 2, // Jarak antar bagian pie
                      centerSpaceRadius: 40, // Ukuran lubang di tengah pie
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Jarak antara pie dan daftar

                // Daftar Kategori dan Persentase di kanan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _categoryData.map((data) { // Tampilkan semua kategori di daftar
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(data['icon'] as IconData?, size: 18, color: data['color'] as Color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                data['name'] as String,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(
                              '${data['percentage'].toStringAsFixed(1)}%',
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
            const SizedBox(height: 30), // Padding di bagian bawah
          ],
        ),
      ),
    );
  }
}