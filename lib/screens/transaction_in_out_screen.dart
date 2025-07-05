// lib/screens/transaction_in_out_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format mata uang

class TransactionInOutScreen extends StatefulWidget {
  const TransactionInOutScreen({super.key});

  @override
  State<TransactionInOutScreen> createState() => _TransactionInOutScreenState();
}

class _TransactionInOutScreenState extends State<TransactionInOutScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController(text: '0');
  String _currentInput = '0'; // String untuk membangun input angka

  String? _selectedExpenseCategory;
  String? _selectedIncomeCategory;

  // Deklarasi oCcy di sini (di dalam State class) agar bisa diakses di semua method
  late final NumberFormat oCcy;

  // Data kategori Pengeluaran
  final List<Map<String, dynamic>> _expenseCategories = [
    {'name': 'Makan', 'icon': Icons.fastfood},
    {'name': 'Minum', 'icon': Icons.local_drink},
    {'name': 'Telepon', 'icon': Icons.phone},
    {'name': 'Hiburan', 'icon': Icons.movie},
    {'name': 'Laundry', 'icon': Icons.local_laundry_service},
    {'name': 'Belanja', 'icon': Icons.shopping_bag},
    {'name': 'Buah', 'icon': Icons.local_florist}, // Ganti ikon buah jika ada yang lebih spesifik
    {'name': 'Sayur', 'icon': Icons.spa}, // Ganti ikon sayur
    {'name': 'Makeup', 'icon': Icons.face_retouching_natural},
    {'name': 'Sehari-hari', 'icon': Icons.event_note},
    {'name': 'Camilan', 'icon': Icons.cookie},
    {'name': 'Edit', 'icon': Icons.edit}, // Placeholder untuk fitur edit kategori
  ];

  // Data kategori Pemasukan
  final List<Map<String, dynamic>> _incomeCategories = [
    {'name': 'Gaji', 'icon': Icons.payments},
    {'name': 'Keuntungan', 'icon': Icons.monetization_on},
    {'name': 'Bonus', 'icon': Icons.card_giftcard},
    {'name': 'Investasi', 'icon': Icons.trending_up},
    {'name': 'Pinjaman', 'icon': Icons.money_off}, // Untuk pengembalian pinjaman
    {'name': 'Lainnya', 'icon': Icons.more_horiz},
    {'name': 'Edit', 'icon': Icons.edit}, // Placeholder untuk fitur edit kategori
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Reset input saat berpindah tab
      _currentInput = '0';
      _amountController.text = _currentInput;
      // Reset pilihan kategori saat berpindah tab
      if (_tabController.index == 0) { // Jika kembali ke pengeluaran
        _selectedIncomeCategory = null;
      } else { // Jika kembali ke pemasukan
        _selectedExpenseCategory = null;
      }
      setState(() {});
    });
    // Inisialisasi oCcy di initState
    oCcy = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onNumberTap(String value) {
    setState(() {
      if (_currentInput == '0' && value != '.') {
        _currentInput = value;
      } else if (value == '.' && _currentInput.contains('.')) {
        // Jangan tambahkan lebih dari satu koma
        return;
      } else if (value == 'x') { // Untuk tombol hapus (backspace)
        if (_currentInput.length > 1) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
        } else {
          _currentInput = '0';
        }
      } else {
        _currentInput += value;
      }
      _amountController.text = _currentInput;
    });
  }

  void _onConfirmTransaction() {
    final double amount = double.tryParse(_currentInput) ?? 0.0;
    String transactionType = _tabController.index == 0 ? 'Pengeluaran' : 'Pemasukan';
    // Ambil nilai category dari state yang benar
    String? category = _tabController.index == 0 ? _selectedExpenseCategory : _selectedIncomeCategory;

    if (amount <= 0 || category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah dan Kategori harus diisi!')),
      );
      return;
    }

    // Lakukan proses menyimpan transaksi ke database atau state management
    print('Menyimpan Transaksi:');
    print('Tipe: $transactionType');
    print('Kategori: $category');
    print('Jumlah: ${oCcy.format(amount)}');
    print('Tanggal: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}'); // Gunakan tanggal saat ini

    // Reset input dan kategori setelah disimpan
    setState(() {
      _currentInput = '0';
      _amountController.text = _currentInput;
      _selectedExpenseCategory = null;
      _selectedIncomeCategory = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaksi ${oCcy.format(amount)} (${category}) berhasil ditambahkan!')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar (Pengeluaran / Pemasukan)
        Container(
          color: Colors.white, // Latar belakang AppBar / TabBar
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.green[600], // Warna indikator tab
            labelColor: Colors.green[800], // Warna teks tab aktif
            unselectedLabelColor: Colors.grey, // Warna teks tab tidak aktif
            tabs: const [
              Tab(text: 'Pengeluaran'),
              Tab(text: 'Pemasukan'),
            ],
          ),
        ),

        // Konten Tab (Kategori dan Input)
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab Pengeluaran
              _buildTransactionInput(
                context,
                isExpense: true,
                categories: _expenseCategories,
                selectedCategory: _selectedExpenseCategory,
                onCategorySelected: (categoryName) {
                  setState(() {
                    _selectedExpenseCategory = categoryName;
                  });
                },
              ),
              // Tab Pemasukan
              _buildTransactionInput(
                context,
                isExpense: false,
                categories: _incomeCategories,
                selectedCategory: _selectedIncomeCategory,
                onCategorySelected: (categoryName) {
                  setState(() {
                    _selectedIncomeCategory = categoryName;
                  });
                },
              ),
            ],
          ),
        ),

        // Area Numpad di bagian bawah
        _buildNumpad(),
      ],
    );
  }

  Widget _buildTransactionInput(
    BuildContext context, {
    required bool isExpense,
    required List<Map<String, dynamic>> categories,
    required String? selectedCategory,
    required Function(String) onCategorySelected,
  }) {
    // oCcy tidak perlu dideklarasikan di sini lagi karena sudah ada di tingkat State
    // final oCcy = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return Container(
      color: Colors.grey[100], // Warna latar belakang konten tab
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Grid Kategori
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(), // Agar GridView tidak scroll
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 ikon per baris
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0, // Rasio lebar:tinggi ikon
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category['name'];
                return InkWell(
                  onTap: () {
                    onCategorySelected(category['name']);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? (isExpense ? Colors.red[100] : Colors.green[100]) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? (isExpense ? Colors.red : Colors.green) : Colors.grey[300]!,
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
                        Icon(category['icon'], color: isSelected ? (isExpense ? Colors.red : Colors.green) : Colors.grey[700]),
                        const SizedBox(height: 4),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? (isExpense ? Colors.red : Colors.green) : Colors.grey[700],
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
          ),
          const SizedBox(height: 20),
          // Input Angka Besar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    readOnly: true, // Input hanya dari numpad
                    textAlign: TextAlign.end, // Rata kanan
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none, // Hapus border default
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                Text(
                  'IDR',
                  style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    return Container(
      color: Colors.grey[200], // Latar belakang numpad
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
              _buildNumpadButton('+'), // Contoh operator, sesuaikan fungsi jika perlu
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

  Widget _buildNumpadButton(String text, {bool isDelete = false, bool isConfirm = false, bool isToday = false}) {
    Color buttonColor = Colors.lightGreen[400]!; // Warna dasar tombol
    Color textColor = Colors.white;

    if (isDelete) {
      buttonColor = Colors.orange[400]!;
      textColor = Colors.white;
    } else if (isConfirm) {
      buttonColor = Colors.green[600]!;
      textColor = Colors.white;
    } else if (isToday) {
      buttonColor = Colors.lightGreen[600]!; // Warna hijau sedikit lebih gelap untuk "Hari ini"
      textColor = Colors.white;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          onPressed: () {
            if (isConfirm) {
              _onConfirmTransaction();
            } else if (isDelete) {
              _onNumberTap('x'); // Kirim 'x' untuk sinyal hapus
            } else if (isToday) {
              // Aksi untuk tombol "Hari ini" (misal, set tanggal transaksi)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tombol "Hari ini" ditekan')),
              );
              // Tambahkan logika untuk mengatur tanggal transaksi jika diperlukan
              // Contoh: _selectedDate = DateTime.now();
            } else {
              _onNumberTap(text);
            }
          },
          child: isDelete ? const Icon(Icons.backspace, color: Colors.white) : Text(
            text,
            style: TextStyle(fontSize: isToday ? 16 : 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}