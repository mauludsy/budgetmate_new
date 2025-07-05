// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format mata uang

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy
    final double totalPengeluaran = 2271000.0;
    final double rataRataHarian = 84111.0;

    final oCcy = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                color: Colors.deepPurple[400],
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Ikon 3 baris (menu) dihapus dari sini.
                    // Jika Anda memiliki Drawer, pertimbangkan bagaimana user akan mengaksesnya.
                    // SizedBox(width: 48), // Jika ingin menjaga layout tanpa ikon menu, bisa pakai ini atau Expanded

                    // Bagian tanggal di tengah (Jun)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: Colors.white),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Bulan Sebelumnya')),
                            );
                          },
                        ),
                        const Text(
                          'Jun', // Bisa diganti dengan bulan dinamis
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, color: Colors.white),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Bulan Selanjutnya')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 48), // Spacer untuk menjaga layout di kanan
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
                            bottom: BorderSide(color: Colors.white, width: 2), // Indikator tab aktif
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

              // Detail Pengeluaran
              Text(
                'Pengeluaran: ${oCcy.format(totalPengeluaran)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rata-rata: ${oCcy.format(rataRataHarian)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),

              const SizedBox(height: 20),

              // Area Grafik
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Area Grafik Ringkasan Bulanan\n(Diisi dengan FlChart mini atau data ringkasan)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Floating Action Buttons (ikon + dan ikon orang) dihapus dari sini.
              // Fungsinya sudah ada di BottomNavigationBar.
              // const SizedBox(height: 20), // Biarkan ini jika perlu padding di bagian bawah
            ],
          ),
        ),
      ),
    );
  }
}