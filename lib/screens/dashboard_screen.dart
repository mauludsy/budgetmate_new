// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget { // UBAH MENJADI StatefulWidget
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> { // Buat kelas State
  // Variabel untuk menyimpan bulan dan tahun yang sedang ditampilkan
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now(); // Inisialisasi dengan bulan/tahun saat ini
  }

  // Fungsi untuk berpindah bulan
  void _changeMonth(int monthsToAdd) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + monthsToAdd,
        _selectedMonth.day, // Biarkan hari tetap sama, Flutter akan menyesuaikan jika tidak valid
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy
    final double totalPengeluaranBulanIni = 2271000.0;
    final double rataRataHarian = 84111.0;
    final double pengeluaranHariIni = 150000.0; // Dummy data
    final double saldoSaatIni = 5500000.0; // Dummy data

    // Format bulan dan tahun yang dipilih
    final String displayMonthYear = DateFormat('MMM yyyy', 'id').format(_selectedMonth);

    final oCcy = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    // Data dummy untuk transaksi terbaru
    final List<Map<String, dynamic>> recentTransactions = [
      {'category': 'Makan Siang', 'amount': 35000.0, 'isExpense': true, 'icon': Icons.fastfood},
      {'category': 'Gaji Bulanan', 'amount': 7000000.0, 'isExpense': false, 'icon': Icons.payments},
      {'category': 'Belanja Bulanan', 'amount': 500000.0, 'isExpense': true, 'icon': Icons.shopping_bag},
      {'category': 'Pulsa Telepon', 'amount': 50000.0, 'isExpense': true, 'icon': Icons.phone},
      {'category': 'Bonus Proyek', 'amount': 1000000.0, 'isExpense': false, 'icon': Icons.card_giftcard},
      {'category': 'Nonton Bioskop', 'amount': 75000.0, 'isExpense': true, 'icon': Icons.movie},
    ];

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Bulan dan Tahun
              Container(
                color: Colors.deepPurple[400],
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: Colors.white),
                          onPressed: () => _changeMonth(-1), // Pindah ke bulan sebelumnya
                        ),
                        Text(
                          displayMonthYear, // Menampilkan bulan dan tahun yang dipilih
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, color: Colors.white),
                          onPressed: () => _changeMonth(1), // Pindah ke bulan selanjutnya
                        ),
                      ],
                    ),
                    const SizedBox(width: 48), // Spacer
                  ],
                ),
              ),

              // Tab Pengeluaran / Pemasukan
              Container(
                color: Colors.deepPurple[400],
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: const Text(
                          'Pengeluaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Text(
                          'Pemasukan',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Detail Pengeluaran Bulan Ini dan Rata-rata
              Text(
                'Pengeluaran Bulan Ini: ${oCcy.format(totalPengeluaranBulanIni)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rata-rata Harian: ${oCcy.format(rataRataHarian)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),

              const SizedBox(height: 20),

              // Area Saldo, Pengeluaran Hari Ini, Bulan Ini
              _buildSummaryCard(
                context,
                oCcy: oCcy,
                saldo: saldoSaatIni,
                pengeluaranHariIni: pengeluaranHariIni,
                pengeluaranBulanIni: totalPengeluaranBulanIni,
              ),

              const SizedBox(height: 20),

              // Area Grafik Utama (placeholder atau grafik FlChart di sini)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Area Grafik Ringkasan Bulanan\n(Misalnya, LineChart atau BarChart sederhana)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Daftar Transaksi Terbaru
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true, // Penting agar ListView bisa di dalam SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Non-scrollable ListView
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = recentTransactions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    elevation: 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: transaction['isExpense'] ? Colors.red[100] : Colors.green[100],
                        child: Icon(
                          transaction['icon'] as IconData,
                          color: transaction['isExpense'] ? Colors.red : Colors.green,
                        ),
                      ),
                      title: Text(
                        transaction['category'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        '${transaction['isExpense'] ? '-' : '+'}${oCcy.format(transaction['amount'])}',
                        style: TextStyle(
                          color: transaction['isExpense'] ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk kartu ringkasan saldo/pengeluaran
  Widget _buildSummaryCard(
    BuildContext context, {
    required NumberFormat oCcy,
    required double saldo,
    required double pengeluaranHariIni,
    required double pengeluaranBulanIni,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Saat Ini',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              oCcy.format(saldo),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pengeluaran Hari Ini', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(
                      oCcy.format(pengeluaranHariIni),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Pengeluaran Bulan Ini', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(
                      oCcy.format(pengeluaranBulanIni),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}