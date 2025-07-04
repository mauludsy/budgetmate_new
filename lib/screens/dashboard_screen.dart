// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budget_mate_app/models/transaction.dart';
import 'package:budget_mate_app/models/category.dart';
import 'package:budget_mate_app/screens/transaction_input_screen.dart';
import 'package:budget_mate_app/screens/split_bill_screen.dart'; // Import halaman Split Bill

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMonthIndex = 5;
  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  final List<Transaction> _allTransactions = [
    Transaction(id: 'j1', title: 'Gaji Bulanan', amount: 8000000, date: DateTime(2025, 6, 1), isExpense: false, category: dummyCategories.firstWhere((cat) => cat.id == 'c5')),
    Transaction(id: 'j2', title: 'Makan Siang', amount: 35000, date: DateTime(2025, 6, 2), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c1')),
    Transaction(id: 'j3', title: 'Bayar Listrik', amount: 250000, date: DateTime(2025, 6, 3), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c13')),
    Transaction(id: 'j4', title: 'Bonus Proyek', amount: 1500000, date: DateTime(2025, 6, 4), isExpense: false, category: dummyCategories.firstWhere((cat) => cat.id == 'c15')),
    Transaction(id: 'j5', title: 'Belanja Bulanan', amount: 800000, date: DateTime(2025, 6, 5), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c7')),
    Transaction(id: 'j6', title: 'Transportasi', amount: 50000, date: DateTime(2025, 6, 6), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c13')),
    Transaction(id: 'j7', title: 'Penjualan Barang Bekas', amount: 120000, date: DateTime(2025, 6, 7), isExpense: false, category: dummyCategories.firstWhere((cat) => cat.id == 'c13')),
    Transaction(id: 'j8', title: 'Hiburan', amount: 150000, date: DateTime(2025, 6, 8), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c4')),
    Transaction(id: 'j9', title: 'Telepon', amount: 80000, date: DateTime(2025, 6, 9), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c3')),
    Transaction(id: 'j10', title: 'Camilan', amount: 50000, date: DateTime(2025, 6, 10), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c12')),
    Transaction(id: 'j11', title: 'Sehari-hari', amount: 30000, date: DateTime(2025, 6, 11), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c11')),
    Transaction(id: 'j12', title: 'Makan Malam', amount: 45000, date: DateTime(2025, 6, 12), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c1')),
    Transaction(id: 'j13', title: 'Minum Kopi', amount: 25000, date: DateTime(2025, 6, 13), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c2')),
    Transaction(id: 'j14', title: 'Beli Buah', amount: 20000, date: DateTime(2025, 6, 14), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c8')),
    Transaction(id: 'j15', title: 'Beli Sayur', amount: 15000, date: DateTime(2025, 6, 15), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c9')),
    Transaction(id: 'j16', title: 'Hiburan', amount: 70000, date: DateTime(2025, 6, 16), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c4')),
    Transaction(id: 'j17', title: 'Pulsa', amount: 50000, date: DateTime(2025, 6, 17), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c3')),
    Transaction(id: 'j18', title: 'Makan Siang', amount: 30000, date: DateTime(2025, 6, 18), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c1')),
    Transaction(id: 'j19', title: 'Camilan', amount: 20000, date: DateTime(2025, 6, 19), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c12')),
    Transaction(id: 'j20', title: 'Transportasi', amount: 40000, date: DateTime(2025, 6, 20), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c13')),
    Transaction(id: 'j21', title: 'Hiburan', amount: 60000, date: DateTime(2025, 6, 21), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c4')),
    Transaction(id: 'j22', title: 'Makan Malam', amount: 50000, date: DateTime(2025, 6, 22), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c1')),
    Transaction(id: 'j23', title: 'Minum', amount: 15000, date: DateTime(2025, 6, 23), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c2')),
    Transaction(id: 'j24', title: 'Belanja', amount: 100000, date: DateTime(2025, 6, 24), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c7')),
    Transaction(id: 'j25', title: 'Sehari-hari', amount: 25000, date: DateTime(2025, 6, 25), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c11')),
    Transaction(id: 'j26', title: 'Makan Siang', amount: 38000, date: DateTime(2025, 6, 26), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c1')),
    Transaction(id: 'j27', title: 'Hiburan', amount: 90000, date: DateTime(2025, 6, 27), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c4')),
    Transaction(id: 'j28', title: 'Telepon', amount: 40000, date: DateTime(2025, 6, 28), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c3')),
    Transaction(id: 'j29', title: 'Camilan', amount: 18000, date: DateTime(2025, 6, 29), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c12')),
    Transaction(id: 'j30', title: 'Lain-lain', amount: 75000, date: DateTime(2025, 6, 30), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c13')),
    Transaction(id: 'a1', title: 'Gaji Mei', amount: 7500000, date: DateTime(2025, 5, 1), isExpense: false, category: dummyCategories.firstWhere((cat) => cat.id == 'c5')),
    Transaction(id: 'a2', title: 'Belanja Mei', amount: 500000, date: DateTime(2025, 5, 10), isExpense: true, category: dummyCategories.firstWhere((cat) => cat.id == 'c7')),
  ];

  List<Transaction> get _currentMonthTransactions {
    return _allTransactions.where((tx) {
      return tx.date.month == (_selectedMonthIndex + 1) && tx.date.year == 2025;
    }).toList();
  }

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
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
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
          SizedBox(width: 48),
        ],
      ),
      drawer: Drawer(
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
                      'A',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Alifa xxxxx',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'ID : 1717224',
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
                Navigator.pop(context);
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
      floatingActionButton: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Tombol Tambah Transaksi (+) (sekarang yang pertama, jadi di kiri)
            FloatingActionButton(
              heroTag: 'addTransactionBtn', // Penting untuk membedakan FAB
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionInputScreen()),
                ).then((value) {
                  if (value != null && value is bool && value) {
                    setState(() {
                      // Trigger rebuild untuk refresh data jika ada perubahan
                    });
                  }
                });
              },
              backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16), // Jarak antara tombol
            // Tombol Split Bill (sekarang yang kedua, jadi di kanan)
            FloatingActionButton(
              heroTag: 'splitBillBtn', // Penting untuk membedakan FAB
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SplitBillScreen()),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.secondary, // Warna berbeda untuk Split Bill
              foregroundColor: Colors.white,
              child: const Icon(Icons.people_alt_outlined), // Ikon untuk Split Bill
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, {required bool isExpenseTab, required List<Transaction> transactions, required double totalAmount}) {
    final averageAmount = transactions.isEmpty ? 0.0 : totalAmount / transactions.length;

    Map<Category, double> categoryTotals = {};
    for (var tx in transactions) {
      categoryTotals.update(tx.category, (value) => value + tx.amount, ifAbsent: () => tx.amount);
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategories = sortedCategories.take(4).toList();

    List<PieChartSectionData> pieChartSections = [];
    if (totalAmount > 0) {
      for (var entry in sortedCategories) {
        final percentage = (entry.value / totalAmount) * 100;
        pieChartSections.add(
          PieChartSectionData(
            color: entry.key.color.shade300,
            value: entry.value,
            title: percentage < 5 ? '' : '${percentage.toStringAsFixed(1)}%',
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
                          final daysInMonth = DateTime(2025, _selectedMonthIndex + 2, 0).day;
                          if (value.toInt() < 1 || value.toInt() > daysInMonth) {
                            return const SizedBox.shrink();
                          }
                          final date = DateTime(2025, _selectedMonthIndex + 1, value.toInt());
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text(DateFormat('dd').format(date), style: const TextStyle(fontSize: 10)),
                          );
                        },
                        interval: 7,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(NumberFormat.compact().format(value), style: const TextStyle(fontSize: 10));
                        },
                        interval: (totalAmount / 3).clamp(10000.0, 10000000.0),
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
                  maxX: DateTime(2025, _selectedMonthIndex + 2, 0).day.toDouble(),
                  minY: 0,
                  maxY: (totalAmount * 1.2).clamp(100000.0, 100000000.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
              Expanded(
                flex: 3,
                child: Column(
                  children: topCategories.map((entry) {
                    final percentage = totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(entry.key.icon, color: entry.key.color.shade800, size: 20),
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

  List<FlSpot> _getLineChartSpots(List<Transaction> transactions, bool isExpense) {
    Map<int, double> dailyTotals = {};
    for (var tx in transactions) {
      final day = tx.date.day;
      dailyTotals.update(day, (value) => value + tx.amount, ifAbsent: () => tx.amount);
    }

    List<FlSpot> spots = [];
    final daysInMonth = DateTime(2025, _selectedMonthIndex + 2, 0).day;
    for (int i = 1; i <= daysInMonth; i++) {
      spots.add(FlSpot(i.toDouble(), dailyTotals[i] ?? 0.0));
    }
    return spots;
  }
}