// lib/screens/transaction_in_out_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Pastikan Anda memiliki api_service.dart jika ingin fungsionalitas API
// import '../services/api_service.dart';

class TransactionInOutScreen extends StatefulWidget {
  const TransactionInOutScreen({super.key});

  @override
  State<TransactionInOutScreen> createState() => _TransactionInOutScreenState();
}

class _TransactionInOutScreenState extends State<TransactionInOutScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController(text: '0');
  String _currentInput = '0';

  String? _selectedExpenseCategory;
  String? _selectedIncomeCategory;

  late final NumberFormat oCcy;

  // Data kategori Pengeluaran
  final List<Map<String, dynamic>> _expenseCategories = [
    {'name': 'Makan', 'icon': Icons.fastfood},
    {'name': 'Minum', 'icon': Icons.local_drink},
    {'name': 'Telepon', 'icon': Icons.phone},
    {'name': 'Hiburan', 'icon': Icons.movie},
    {'name': 'Laundry', 'icon': Icons.local_laundry_service},
    {'name': 'Belanja', 'icon': Icons.shopping_bag},
    {'name': 'Buah', 'icon': Icons.local_florist},
    {'name': 'Sayur', 'icon': Icons.eco},
    {'name': 'Makeup', 'icon': Icons.face_retouching_natural},
    {'name': 'Sehari-hari', 'icon': Icons.event_note},
    {'name': 'Camilan', 'icon': Icons.cookie},
    {'name': 'Edit', 'icon': Icons.edit},
  ];

  // Data kategori Pemasukan
  final List<Map<String, dynamic>> _incomeCategories = [
    {'name': 'Gaji', 'icon': Icons.payments},
    {'name': 'Keuntungan', 'icon': Icons.monetization_on},
    {'name': 'Bonus', 'icon': Icons.card_giftcard},
    {'name': 'Investasi', 'icon': Icons.trending_up},
    {'name': 'Pinjaman', 'icon': Icons.account_balance_wallet},
    {'name': 'Lainnya', 'icon': Icons.more_horiz},
    {'name': 'Edit', 'icon': Icons.edit},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _currentInput = '0';
        _amountController.text = oCcy.format(0);
        // Reset pilihan kategori saat berpindah tab
        if (_tabController.index == 0) {
          _selectedIncomeCategory = null;
        } else {
          _selectedExpenseCategory = null;
        }
        setState(() {});
      }
    });
    oCcy = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    _amountController.text = oCcy.format(0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onNumberTap(String value) {
    setState(() {
      if (value == 'x') {
        if (_currentInput.length > 1) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
        } else {
          _currentInput = '0';
        }
      } else if (value == '.') {
        if (!_currentInput.contains('.')) {
          _currentInput += value;
        }
      } else {
        if (_currentInput == '0' && value != '.') {
          _currentInput = value;
        } else {
          _currentInput += value;
        }
      }
      double displayAmount = double.tryParse(_currentInput) ?? 0.0;
      _amountController.text = oCcy.format(displayAmount);
    });
  }

  void _onConfirmTransaction() {
    final double amount = double.tryParse(_currentInput) ?? 0.0;
    String transactionType = _tabController.index == 0 ? 'Pengeluaran' : 'Pemasukan';
    String? category = _tabController.index == 0 ? _selectedExpenseCategory : _selectedIncomeCategory;

    if (amount <= 0 || category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah dan Kategori harus diisi!')),
      );
      return;
    }

    // Simulasi berhasil
    final success = true; // Ganti ini dengan hasil dari panggilan API Anda
    // final success = await ApiService.createTransaction(...);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi ${oCcy.format(amount)} (${category}) berhasil ditambahkan!')),
      );
      setState(() {
        _currentInput = '0';
        _amountController.text = oCcy.format(0);
        _selectedExpenseCategory = null;
        _selectedIncomeCategory = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan transaksi!')),
      );
    }
  }

  // Widget untuk membangun kategori grid
  Widget _buildCategoryGrid(
      List<Map<String, dynamic>> categories,
      String? selectedCategory,
      Function(String) onCategorySelected,
      bool isExpense, // Menentukan apakah ini kategori pengeluaran atau pemasukan untuk warna
      ) {
    return Container(
      color: Colors.white, // Latar belakang untuk kategori grid
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true, // Penting agar GridView mengambil tinggi sesuai kontennya
        physics: const NeverScrollableScrollPhysics(), // Agar GridView tidak scroll secara terpisah
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 ikon per baris
          crossAxisSpacing: 12.0, // Jarak antar ikon horizontal
          mainAxisSpacing: 12.0, // Jarak antar ikon vertikal
          childAspectRatio: 1.0, // Rasio lebar:tinggi ikon
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = selectedCategory == category['name'];
          Color primaryColor = isExpense ? Colors.red.shade400 : Colors.green.shade400;
          Color lightColor = isExpense ? Colors.red.shade50 : Colors.green.shade50;
          Color normalColor = Colors.grey.shade700;

          // **Responsivitas untuk ikon kategori:**
          // Menggunakan ukuran yang sedikit lebih besar agar lebih terlihat di ponsel.
          final double iconSize = 32.0; // Ditingkatkan dari 28.0 untuk responsivitas yang lebih baik
          final double fontSize = 12.0; // Sedikit ditingkatkan untuk keterbacaan

          return InkWell(
            onTap: () {
              onCategorySelected(category['name']);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? lightColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade300!,
                  width: isSelected ? 2.0 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'],
                    color: isSelected ? primaryColor : normalColor,
                    size: iconSize, // Menerapkan ukuran responsif
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: fontSize, // Menerapkan ukuran font responsif
                      color: isSelected ? primaryColor : normalColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget untuk membangun Numpad
  Widget _buildNumpad() {
    return Container(
      color: Colors.grey[100], // Latar belakang numpad
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('1'),
              _buildNumpadButton('2'),
              _buildNumpadButton('3'),
              _buildNumpadButton('x', isDelete: true), // Ikon hapus (backspace)
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('4'),
              _buildNumpadButton('5'),
              _buildNumpadButton('6'),
              _buildNumpadButton('+'), // Contoh operator
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('7'),
              _buildNumpadButton('8'),
              _buildNumpadButton('9'),
              _buildNumpadButton('-'), // Contoh operator
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('.'),
              _buildNumpadButton('0'),
              _buildNumpadButton('Hari ini', isToday: true), // Tombol "Hari ini"
              _buildNumpadButton('✔️', isConfirm: true), // Tombol konfirmasi
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun tombol Numpad individual
  Widget _buildNumpadButton(String text, {bool isDelete = false, bool isConfirm = false, bool isToday = false}) {
    Color buttonColor = Colors.green.shade200!; // Warna dasar tombol angka
    Color textColor = Colors.black87; // Warna teks default untuk angka

    if (isDelete) {
      buttonColor = Colors.orange.shade500!;
      textColor = Colors.white;
    } else if (isConfirm) {
      buttonColor = Colors.green.shade700!;
      textColor = Colors.white;
    } else if (isToday) {
      buttonColor = Colors.green.shade500!;
      textColor = Colors.white;
    }

    // **Responsivitas untuk teks/ikon tombol numpad:**
    // Menyesuaikan ukuran font untuk tampilan ponsel yang lebih baik.
    final double numpadFontSize = isToday ? 16 : 28; // Ditingkatkan dari 24 untuk visibilitas yang lebih baik
    final double deleteIconSize = 28.0; // Ditingkatkan dari 24.0

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Sesuaikan radius dengan gambar
            ),
            elevation: 0,
          ),
          onPressed: () {
            if (isConfirm) {
              _onConfirmTransaction();
            } else if (isDelete) {
              _onNumberTap('x');
            } else if (isToday) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tombol "Hari ini" ditekan')),
              );
            } else {
              _onNumberTap(text);
            }
          },
          child: isDelete
              ? Icon(Icons.backspace, color: Colors.white, size: deleteIconSize) // Menerapkan ukuran responsif
              : Text(
            text,
            style: TextStyle(fontSize: numpadFontSize, fontWeight: FontWeight.bold), // Menerapkan ukuran font responsif
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // KINI WIDGET INI HANYA MENGEMBALIKAN KONTEN UTAMA, BUKAN SCAFFOLD LENGKAP.
    // SCAFFOLD, APPBAR, DAN BOTTOMNAVIGATIONBAR AKAN ADA DI WIDGET INDUK.
    return Column(
      children: [
        // Tab Bar (Pengeluaran / Pemasukan)
        Container(
          color: Colors.white, // Latar belakang TabBar
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.green.shade600, // Warna indikator tab
            labelColor: Colors.green.shade800, // Warna teks tab aktif
            unselectedLabelColor: Colors.grey.shade600, // Warna teks tab tidak aktif
            tabs: const [
              Tab(text: 'Pengeluaran'),
              Tab(text: 'Pemasukan'),
            ],
          ),
        ),

        // Konten Tab (Kategori dan Input Angka)
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab Pengeluaran
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCategoryGrid(
                      _expenseCategories,
                      _selectedExpenseCategory,
                      (categoryName) {
                        setState(() {
                          _selectedExpenseCategory = categoryName;
                        });
                      },
                      true, // isExpense: true
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade300!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                readOnly: true,
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                              ),
                            ),
                            Text(
                              'IDR',
                              style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Tab Pemasukan
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCategoryGrid(
                      _incomeCategories,
                      _selectedIncomeCategory,
                      (categoryName) {
                        setState(() {
                          _selectedIncomeCategory = categoryName;
                        });
                      },
                      false, // isExpense: false
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade300!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                readOnly: true,
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                              ),
                            ),
                            Text(
                              'IDR',
                              style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Area Numpad di bagian paling bawah
        _buildNumpad(),
      ],
    );
  }
}