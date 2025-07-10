// Revisi lengkap TransactionInOutScreen agar bebas dari error Material dan overflow
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class TransactionInOutScreen extends StatefulWidget {
  const TransactionInOutScreen({super.key});

  @override
  State<TransactionInOutScreen> createState() => _TransactionInOutScreenState();
}

class _TransactionInOutScreenState extends State<TransactionInOutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController(text: '0');
  String _currentInput = '0';

  String? _selectedExpenseCategory;
  String? _selectedIncomeCategory;

  late final NumberFormat oCcy;

  final List<Map<String, dynamic>> _expenseCategories = [
    {'name': 'Makan', 'icon': Icons.fastfood},
    {'name': 'Minum', 'icon': Icons.local_drink},
    {'name': 'Belanja', 'icon': Icons.shopping_bag},
    {'name': 'Transport', 'icon': Icons.directions_car},
    {'name': 'Lainnya', 'icon': Icons.more_horiz},
  ];

  final List<Map<String, dynamic>> _incomeCategories = [
    {'name': 'Gaji', 'icon': Icons.payments},
    {'name': 'Bonus', 'icon': Icons.card_giftcard},
    {'name': 'Investasi', 'icon': Icons.trending_up},
    {'name': 'Lainnya', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    oCcy = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    _amountController.text = oCcy.format(0);
    _tabController = TabController(length: 2, vsync: this);
  }

  void _onNumberTap(String value) {
    setState(() {
      if (value == 'x') {
        _currentInput = _currentInput.length > 1
            ? _currentInput.substring(0, _currentInput.length - 1)
            : '0';
      } else if (value == '.') {
        if (!_currentInput.contains('.')) _currentInput += value;
      } else {
        _currentInput = _currentInput == '0' ? value : _currentInput + value;
      }
      final double parsed = double.tryParse(_currentInput.replaceAll('.', '').replaceAll(',', '')) ?? 0;
      _amountController.text = oCcy.format(parsed);
    });
  }

  void _onConfirmTransaction() async {
    final double amount = double.tryParse(_currentInput.replaceAll('.', '').replaceAll(',', '')) ?? 0.0;
    String transactionType = _tabController.index == 0 ? 'expense' : 'income';
    String? category = _tabController.index == 0 ? _selectedExpenseCategory : _selectedIncomeCategory;
    final String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (amount <= 0 || category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah dan Kategori harus diisi!')),
      );
      return;
    }

    final success = await ApiService.createTransaction(
      amount: amount,
      category: category,
      type: transactionType,
      date: date,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi ${oCcy.format(amount)} berhasil ditambahkan!')),
      );
      Navigator.pop(context, true); // kembali ke dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan transaksi!')),
      );
    }
  }

  Widget _buildCategoryGrid(List<Map<String, dynamic>> categories, String? selectedCategory, bool isExpense) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        final bool isSelected = selectedCategory == category['name'];
        final Color color = isExpense ? Colors.red : Colors.green;
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isExpense) {
                _selectedExpenseCategory = category['name'];
              } else {
                _selectedIncomeCategory = category['name'];
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: isSelected ? color : Colors.grey),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? color.withOpacity(0.2) : Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'], color: isSelected ? color : Colors.grey),
                const SizedBox(height: 4),
                Text(category['name'], style: TextStyle(color: isSelected ? color : Colors.black))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumpad() {
    final List<List<String>> buttons = [
      ['1', '2', '3', 'x'],
      ['4', '5', '6', ''],
      ['7', '8', '9', ''],
      ['.', '0', '✔️', ''],
    ];

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: buttons.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((text) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: text == '✔️'
                          ? Colors.green
                          : text == 'x'
                              ? Colors.red
                              : Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: text.isEmpty
                        ? null
                        : () {
                            if (text == '✔️') {
                              _onConfirmTransaction();
                            } else {
                              _onNumberTap(text);
                            }
                          },
                    child: text == 'x'
                        ? const Icon(Icons.backspace)
                        : Text(text, style: const TextStyle(fontSize: 20)),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Pengeluaran'),
                Tab(text: 'Pemasukan'),
              ],
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCategoryGrid(_expenseCategories, _selectedExpenseCategory, true),
                      _buildAmountInput(),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCategoryGrid(_incomeCategories, _selectedIncomeCategory, false),
                      _buildAmountInput(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildNumpad(),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Jumlah:', style: TextStyle(fontSize: 18)),
            Text(_amountController.text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
