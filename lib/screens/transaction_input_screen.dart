// lib/screens/transaction_input_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_mate_app/models/category.dart'; // Import model Category

class TransactionInputScreen extends StatefulWidget {
  const TransactionInputScreen({super.key});

  @override
  State<TransactionInputScreen> createState() => _TransactionInputScreenState();
}

class _TransactionInputScreenState extends State<TransactionInputScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentAmount = '0';
  Category? _selectedCategory; // Kategori yang dipilih
  bool _isExpense = true; // Default ke pengeluaran

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _isExpense = _tabController.index == 0; // 0 untuk Pengeluaran, 1 untuk Pemasukan
      _selectedCategory = null; // Reset kategori saat tab berubah
      _currentAmount = '0'; // Reset jumlah saat tab berubah
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _onNumberTap(String number) {
    setState(() {
      if (_currentAmount == '0' && number != '.') {
        _currentAmount = number;
      } else {
        _currentAmount += number;
      }
    });
  }

  void _onOperatorTap(String operator) {
    setState(() {
      // Implementasi kalkulator sederhana (hanya untuk demo)
      // Untuk kalkulator penuh, Anda perlu parsing ekspresi
      if (operator == 'X') { // Clear
        _currentAmount = '0';
      } else if (operator == '<') { // Backspace
        if (_currentAmount.length > 1) {
          _currentAmount = _currentAmount.substring(0, _currentAmount.length - 1);
        } else {
          _currentAmount = '0';
        }
      } else if (operator == '=') {
        // Lakukan perhitungan jika ada operator
        // Contoh sangat sederhana: hanya bisa menambah atau kurang
        if (_currentAmount.contains('+')) {
          final parts = _currentAmount.split('+');
          if (parts.length == 2) {
            _currentAmount = (double.parse(parts[0]) + double.parse(parts[1])).toStringAsFixed(0);
          }
        } else if (_currentAmount.contains('-')) {
          final parts = _currentAmount.split('-');
          if (parts.length == 2) {
            _currentAmount = (double.parse(parts[0]) - double.parse(parts[1])).toStringAsFixed(0);
          }
        }
      } else {
        // Tambahkan operator ke string (untuk demo sederhana)
        if (!_currentAmount.contains(operator)) {
          _currentAmount += operator;
        }
      }
    });
  }

  void _onSaveTransaction() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori terlebih dahulu!')),
      );
      return;
    }
    if (double.tryParse(_currentAmount) == null || double.parse(_currentAmount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan jumlah yang valid!')),
      );
      return;
    }

    // Logika untuk menyimpan transaksi (akan diintegrasikan dengan backend nanti)
    print('Transaksi ${_isExpense ? "Pengeluaran" : "Pemasukan"} disimpan:');
    print('Jumlah: $_currentAmount');
    print('Kategori: ${_selectedCategory!.name}');
    print('Tanggal: ${DateTime.now()}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaksi ${_selectedCategory!.name} Rp${NumberFormat('#,##0', 'id_ID').format(double.parse(_currentAmount))} berhasil dicatat!')),
    );

    // Kembali ke dashboard setelah menyimpan
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Filter kategori berdasarkan tipe transaksi (pengeluaran/pemasukan)
    final List<Category> filteredCategories = _isExpense
        ? dummyCategories.where((cat) => cat.name != 'Gaji' && cat.name != 'Bonus').toList() // Kategori pengeluaran
        : dummyCategories.where((cat) => cat.name == 'Gaji' || cat.name == 'Bonus' || cat.name == 'Lain-lain').toList(); // Kategori pemasukan sederhana

    return Scaffold(
      appBar: AppBar(
        leading: IconButton( // Tombol kembali
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TabBar(
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
      ),
      body: SingleChildScrollView( // <--- PERBAIKAN DI SINI: Bungkus Column dengan SingleChildScrollView
        child: Column( // Main Column
          children: [
            // Bagian Kategori
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll GridView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 kolom
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1, // Rasio aspek 1:1 untuk item grid
                ),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  final isSelected = _selectedCategory?.id == category.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Card(
                      color: isSelected ? category.color.shade700 : category.color.shade100, // Adjusted shades for better contrast
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: isSelected ? BorderSide(color: category.color.shade900, width: 2) : BorderSide.none, // Darker border for selected
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category.icon, color: isSelected ? Colors.white : category.color.shade800, size: 30),
                          const SizedBox(height: 5),
                          Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input Jumlah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberFormat('#,##0', 'id_ID').format(double.tryParse(_currentAmount) ?? 0),
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _selectedCategory != null ? _selectedCategory!.name : 'Pilih Kategori',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            // Keypad Kalkulator
            SizedBox( // <--- Bungkus Expanded dengan SizedBox untuk mengontrol tinggi
              height: MediaQuery.of(context).size.height * 0.4, // Contoh: Ambil 40% tinggi layar
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5, // Rasio aspek untuk tombol
                ),
                itemCount: _keypadButtons.length,
                itemBuilder: (context, index) {
                  final buttonText = _keypadButtons[index];
                  return _buildKeypadButton(buttonText);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String text) {
    Color buttonColor = Colors.grey.shade200;
    Color textColor = Colors.black87;
    Widget? icon;

    if (text == 'X') { // Clear
      buttonColor = Colors.red.shade100;
      textColor = Colors.red.shade700;
      icon = const Icon(Icons.close, color: Colors.red);
    } else if (text == '<') { // Backspace
      buttonColor = Colors.orange.shade100;
      textColor = Colors.orange.shade700;
      icon = const Icon(Icons.backspace, color: Colors.orange);
    } else if (text == 'Hari ini') {
      buttonColor = Colors.blue.shade100;
      textColor = Colors.blue.shade700;
    } else if (text == '✓') { // Save
      buttonColor = Colors.green.shade600;
      textColor = Colors.white;
      icon = const Icon(Icons.check, color: Colors.white);
    } else if (double.tryParse(text) != null || text == '.') {
      buttonColor = Colors.white;
    } else { // Operators
      buttonColor = Colors.grey.shade300;
    }

    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (text == '✓') {
            _onSaveTransaction();
          } else if (text == 'Hari ini') {
            // Placeholder for date selection
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur pilih tanggal akan datang!')),
            );
          } else {
            _onNumberTap(text);
          }
        },
        onLongPress: () {
          if (text == '<') {
            setState(() {
              _currentAmount = '0'; // Long press backspace to clear
            });
          }
        },
        child: Center(
          child: icon ?? Text(
            text,
            style: TextStyle(
              fontSize: text == 'Hari ini' ? 14 : 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  final List<String> _keypadButtons = [
    '1', '2', '3', '+',
    '4', '5', '6', '-',
    '7', '8', '9', 'X', // X for clear
    '.', '0', '<', '✓', // < for backspace, ✓ for save
  ];
}
