// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:budget_mate_app/models/transaction.dart';
import 'package:budget_mate_app/models/category.dart';
import 'package:budget_mate_app/screens/transaction_input_screen.dart'; // Import layar input transaksi

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMonthIndex = 5; // Juni (indeks 5)
  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  // Data dummy transaksi yang lebih detail
  final List<Transaction> _allTransactions = [
    // Juni
    Transaction(id: 'j1', title: 'Gaji Bulanan', amount: 8000000, date: DateTime(2025, 6, 1), isExpense: false, category: dummyCategories.firstWhere((cat) => cat.name == 'Gaji')),
    Transaction(id: 'j2', title: 'Makan Siang', amount: 35000, date: DateTime(2025, 6, 2), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Makan')),
    Transaction(id: 'j3', title: 'Bayar Listrik', amount: 250000, date: DateTime(2025, 6, 3), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Lain-lain')),
    Transaction(id: 'j4', title: 'Bonus Proyek', amount: 1500000, date: DateTime(2025, 6, 4), isExpense: false, category: dummyCategories.firstWhere((cat) => cat.name == 'Bonus')),
    Transaction(id: 'j5', title: 'Belanja Bulanan', amount: 800000, date: DateTime(2025, 6, 5), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Belanja')),
    Transaction(id: 'j6', title: 'Transportasi', amount: 50000, date: DateTime(2025, 6, 6), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Lain-lain')),
    Transaction(id: 'j7', title: 'Penjualan Barang Bekas', amount: 120000, date: DateTime(2025, 6, 7), isExpense: false, category: dummyCategories.firstWhere((cat) => cat.name == 'Lain-lain')),
    Transaction(id: 'j8', title: 'Hiburan', amount: 150000, date: DateTime(2025, 6, 8), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Hiburan')),
    Transaction(id: 'j9', title: 'Telepon', amount: 80000, date: DateTime(2025, 6, 9), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Telepon')),
    Transaction(id: 'j10', title: 'Camilan', amount: 50000, date: DateTime(2025, 6, 10), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Camilan')),
    Transaction(id: 'j11', title: 'Sehari-hari', amount: 30000, date: DateTime(2025, 6, 11), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Sehari-hari')),
    Transaction(id: 'j12', title: 'Makan Malam', amount: 45000, date: DateTime(2025, 6, 12), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Makan')),
    Transaction(id: 'j13', title: 'Minum Kopi', amount: 25000, date: DateTime(2025, 6, 13), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Minum')),
    Transaction(id: 'j14', title: 'Beli Buah', amount: 20000, date: DateTime(2025, 6, 14), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Buah')),
    Transaction(id: 'j15', title: 'Beli Sayur', amount: 15000, date: DateTime(2025, 6, 15), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Sayur')),
    Transaction(id: 'j16', title: 'Hiburan', amount: 70000, date: DateTime(2025, 6, 16), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Hiburan')),
    Transaction(id: 'j17', title: 'Pulsa', amount: 50000, date: DateTime(2025, 6, 17), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Telepon')),
    Transaction(id: 'j18', title: 'Makan Siang', amount: 30000, date: DateTime(2025, 6, 18), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Makan')),
    Transaction(id: 'j19', title: 'Camilan', amount: 20000, date: DateTime(2025, 6, 19), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Camilan')),
    Transaction(id: 'j20', title: 'Transportasi', amount: 40000, date: DateTime(2025, 6, 20), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Lain-lain')),
    Transaction(id: 'j21', title: 'Hiburan', amount: 60000, date: DateTime(2025, 6, 21), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Hiburan')),
    Transaction(id: 'j22', title: 'Makan Malam', amount: 50000, date: DateTime(2025, 6, 22), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Makan')),
    Transaction(id: 'j23', title: 'Minum', amount: 15000, date: DateTime(2025, 6, 23), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Minum')),
    Transaction(id: 'j24', title: 'Belanja', amount: 100000, date: DateTime(2025, 6, 24), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Belanja')),
    Transaction(id: 'j25', title: 'Sehari-hari', amount: 25000, date: DateTime(2025, 6, 25), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Sehari-hari')),
    Transaction(id: 'j26', title: 'Makan Siang', amount: 38000, date: DateTime(2025, 6, 26), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Makan')),
    Transaction(id: 'j27', title: 'Hiburan', amount: 90000, date: DateTime(2025, 6, 27), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Hiburan')),
    Transaction(id: 'j28', title: 'Telepon', amount: 40000, date: DateTime(2025, 6, 28), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Telepon')),
    Transaction(id: 'j29', title: 'Camilan', amount: 18000, date: DateTime(2025, 6, 29), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Camilan')),
    Transaction(id: 'j30', title: 'Lain-lain', amount: 75000, date: DateTime(2025, 6, 30), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.name == 'Lain-lain')),
  ];

  List<Transaction> get _currentMonthTransactions {
    return _allTransactions.where((tx) {
      return tx.date.month == (_selectedMonthIndex + 1) && tx.date.year == 2025;
    }).toList();
  }

  // GlobalKey untuk mengakses ScaffoldState dan membuka Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenseTransactions = _currentMonthTransactions.where((tx) => tx.isExpense).toList();
    final incomeTransactions = _currentMonthTransactions.where((tx) => !tx.isExpense).toList();

    double totalExpense = expenseTransactions.fold(0.0, (sum, tx) => sum + tx.amount);
    double totalIncome = incomeTransactions.fold(0.0, (sum, tx) => sum + tx.amount);

    return Scaffold(
      key: _scaffoldKey, // Tetapkan GlobalKey ke Scaffold
      appBar: AppBar(
        leading: IconButton( // Tombol untuk membuka Drawer
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Buka Drawer
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
              onPressed: () {
                setState(() {
                  _selectedMonthIndex = (_selectedMonthIndex - 1 + _months.length) % _months.length;
                });
              },
            ),
            Text(
              _months[_selectedMonthIndex],
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
              onPressed: () {
                setState(() {
                  _selectedMonthIndex = (_selectedMonthIndex + 1) % _months.length;
                });
              },
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: 'Pengeluaran'),
            Tab(text: 'Pemasukan'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: const [
          SizedBox(width: 48), // Spacer untuk menyeimbangkan leading icon
        ],
      ),
      drawer: Drawer( // Widget Drawer untuk menu samping
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      'A', // Inisial pengguna
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Alifa xxxxx', // Nama pengguna
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'ID : 1717224', // ID pengguna
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1),
              title: const Text('Rekomendasi ke teman'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rekomendasi ke teman ditekan!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.diamond),
              title: const Text('Anggota premium'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Anggota premium ditekan!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_rate),
              title: const Text('Nilai Aplikasi'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nilai Aplikasi ditekan!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Tema'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tema ditekan!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pengaturan ditekan!')),
                );
              },
            ),
            // Anda bisa menambahkan Divider atau item lain di sini
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(context, isExpenseTab: true, transactions: expenseTransactions, totalAmount: totalExpense),
          _buildTabContent(context, isExpenseTab: false, transactions: incomeTransactions, totalAmount: totalIncome),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransactionInputScreen()),
          );
        },
        backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTabContent(BuildContext context, {required bool isExpenseTab, required List<Transaction> transactions, required double totalAmount}) {
    final averageAmount = transactions.isEmpty ? 0.0 : totalAmount / transactions.length;

    // Hitung total pengeluaran/pemasukan per kategori
    Map<Category, double> categoryTotals = {};
    for (var tx in transactions) {
      categoryTotals.update(tx.category, (value) => value + tx.amount, ifAbsent: () => tx.amount);
    }

    // Urutkan kategori berdasarkan jumlah (terbesar ke terkecil)
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Ambil 4 kategori teratas untuk peringkat
    final topCategories = sortedCategories.take(4).toList();

    // Data untuk Pie Chart
    List<PieChartSectionData> pieChartSections = [];
    if (totalAmount > 0) {
      for (var entry in sortedCategories) {
        final percentage = (entry.value / totalAmount) * 100;
        pieChartSections.add(
          PieChartSectionData(
            color: entry.key.color.shade300, // Menggunakan shade300 untuk warna di pie chart
            value: entry.value,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      // Tampilkan bagian kosong jika tidak ada data
      pieChartSections.add(
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 100,
          title: '0%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      );
    }


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ringkasan Pengeluaran/Pemasukan dan Rata-rata
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${isExpenseTab ? 'Pengeluaran' : 'Pemasukan'}: Rp${NumberFormat('#,##0', 'id_ID').format(totalAmount)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rata-rata: Rp${NumberFormat('#,##0', 'id_ID').format(averageAmount)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Line Chart
          AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          // Tampilkan label tanggal setiap 7 hari atau sesuai kebutuhan
                          final date = DateTime(2025, _selectedMonthIndex + 1, value.toInt());
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text(DateFormat('dd').format(date), style: const TextStyle(fontSize: 10)),
                          );
                        },
                        interval: 7, // Tampilkan label setiap 7 hari
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(NumberFormat.compact().format(value), style: const TextStyle(fontSize: 10));
                        },
                        interval: (totalAmount / 3).clamp(10000, 1000000).toDouble(), // Sesuaikan interval
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getLineChartSpots(transactions, isExpenseTab),
                      isCurved: true,
                      color: isExpenseTab ? Colors.redAccent : Colors.greenAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (isExpenseTab ? Colors.redAccent : Colors.greenAccent).withOpacity(0.3),
                      ),
                    ),
                  ],
                  minX: 1,
                  maxX: DateTime(2025, _selectedMonthIndex + 2, 0).day.toDouble(), // Jumlah hari dalam bulan
                  minY: 0,
                  maxY: (totalAmount * 1.2).clamp(100000, 10000000).toDouble(), // Sesuaikan Y max
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Peringkat Kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Peringkat Kategori',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pie Chart
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sections: pieChartSections,
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ),
              // Daftar Peringkat Kategori
              Expanded(
                flex: 3,
                child: Column(
                  children: topCategories.map((entry) {
                    final percentage = (entry.value / totalAmount) * 100;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(entry.key.icon, color: entry.key.color.shade800, size: 20), // Menggunakan shade800
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.key.name,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper untuk mendapatkan data spot Line Chart
  List<FlSpot> _getLineChartSpots(List<Transaction> transactions, bool isExpense) {
    Map<int, double> dailyTotals = {};
    for (var tx in transactions) {
      final day = tx.date.day;
      dailyTotals.update(day, (value) => value + tx.amount, ifAbsent: () => tx.amount);
    }

    List<FlSpot> spots = [];
    final daysInMonth = DateTime(2025, _selectedMonthIndex + 2, 0).day; // Jumlah hari dalam bulan
    for (int i = 1; i <= daysInMonth; i++) {
      spots.add(FlSpot(i.toDouble(), dailyTotals[i] ?? 0.0));
    }
    return spots;
  }
}
