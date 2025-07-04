import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_mate_app/models/category.dart';
import 'package:budget_mate_app/models/transaction.dart';

class TransactionInputScreen extends StatefulWidget {
  const TransactionInputScreen({super.key});

  @override
  State<TransactionInputScreen> createState() => _TransactionInputScreenState();
}

class _TransactionInputScreenState extends State<TransactionInputScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  late TabController _tabController;
  Category? _selectedExpenseCategory;
  Category? _selectedIncomeCategory;
  DateTime _selectedDate = DateTime.now();

  late final List<Category> _expenseCategories;
  late final List<Category> _incomeCategories;

  String _currentInput = '0';
  bool _isDecimalAdded = false;

  _TransactionInputScreenState() {
    _expenseCategories = dummyCategories.where((cat) =>
        cat.name != 'Gaji' && cat.name != 'Keuntungan' && cat.name != 'Bonus'
    ).toList();
    _incomeCategories = dummyCategories.where((cat) =>
        cat.name == 'Gaji' || cat.name == 'Keuntungan' || cat.name == 'Bonus' || cat.name == 'Lain-lain'
    ).toList();
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _amountController.text = _currentInput;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _onDigitPressed(String digit) {
    setState(() {
      if (_currentInput == '0' && digit != '.') {
        _currentInput = digit;
      } else if (digit == '.') {
        if (!_isDecimalAdded && !_currentInput.contains('.')) {
          _currentInput += digit;
          _isDecimalAdded = true;
        }
      } else {
        _currentInput += digit;
      }
      _amountController.text = _currentInput;
    });
  }

  void _onClearPressed() {
    setState(() {
      _currentInput = '0';
      _isDecimalAdded = false;
      _amountController.text = _currentInput;
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (_currentInput.length > 1) {
        if (_currentInput.endsWith('.')) {
          _isDecimalAdded = false;
        }
        _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      } else {
        _currentInput = '0';
        _isDecimalAdded = false;
      }
      _amountController.text = _currentInput;
    });
  }

  Widget _buildCategoryItem(Category category, bool isExpenseTab) {
    final isSelected = isExpenseTab
        ? _selectedExpenseCategory?.id == category.id
        : _selectedIncomeCategory?.id == category.id;

    return InkWell(
      onTap: () {
        setState(() {
          if (isExpenseTab) {
            _selectedExpenseCategory = category;
          } else {
            _selectedIncomeCategory = category;
          }
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? category.color.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? category.color : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              size: 30,
              color: isSelected ? category.color.shade800 : category.color.shade600,
            ),
            const SizedBox(height: 5),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? category.color.shade900 : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalcButton(String text, {Color? backgroundColor, Color? foregroundColor, VoidCallback? onPressed, Widget? iconChild}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.grey.shade200,
            foregroundColor: foregroundColor ?? Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: iconChild ?? Text(
            text,
            style: TextStyle(fontSize: (text == 'Hari ini') ? 18 : 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
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
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionInputTab(true),
          _buildTransactionInputTab(false),
        ],
      ),
    );
  }

  Widget _buildTransactionInputTab(bool isExpenseTab) {
    final List<Category> categoriesToShow = isExpenseTab ? _expenseCategories : _incomeCategories;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 10.0),
                    child: Text(
                      'Rp${NumberFormat('#,##0', 'id_ID').format(double.tryParse(_currentInput) ?? 0)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                ),
                Text(
                  'Pilih Kategori:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: categoriesToShow.length,
                  itemBuilder: (ctx, index) {
                    return _buildCategoryItem(categoriesToShow[index], isExpenseTab);
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tanggal: ${DateFormat('dd MMMM yyyy').format(_selectedDate)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.grey.shade50,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildCalcButton('1', onPressed: () => _onDigitPressed('1')),
                  _buildCalcButton('2', onPressed: () => _onDigitPressed('2')),
                  _buildCalcButton('3', onPressed: () => _onDigitPressed('3')),
                  _buildCalcButton('X', onPressed: _onBackspacePressed, backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildCalcButton('4', onPressed: () => _onDigitPressed('4')),
                  _buildCalcButton('5', onPressed: () => _onDigitPressed('5')),
                  _buildCalcButton('6', onPressed: () => _onDigitPressed('6')),
                  _buildCalcButton('+', onPressed: () { }),
                ],
              ),
              Row(
                children: [
                  _buildCalcButton('7', onPressed: () => _onDigitPressed('7')),
                  _buildCalcButton('8', onPressed: () => _onDigitPressed('8')),
                  _buildCalcButton('9', onPressed: () => _onDigitPressed('9')),
                  _buildCalcButton('-', onPressed: () { }),
                ],
              ),
              Row(
                children: [
                  _buildCalcButton('.', onPressed: () => _onDigitPressed('.')),
                  _buildCalcButton('0', onPressed: () => _onDigitPressed('0')),
                  _buildCalcButton('Hari ini', onPressed: () {
                    setState(() {
                      _selectedDate = DateTime.now();
                    });
                  }, backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white),
                  _buildCalcButton(
                    '',
                    onPressed: () {
                      final enteredAmount = double.tryParse(_currentInput);
                      if (enteredAmount == null || enteredAmount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Masukkan jumlah yang valid!')),
                        );
                        return;
                      }

                      final selectedCategory = isExpenseTab ? _selectedExpenseCategory : _selectedIncomeCategory;
                      if (selectedCategory == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pilih kategori!')),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Transaksi ${isExpenseTab ? "Pengeluaran" : "Pemasukan"} Rp${NumberFormat('#,##0', 'id_ID').format(enteredAmount)} untuk ${selectedCategory.name} pada ${DateFormat('dd MMM yyyy').format(_selectedDate)} disimpan!'),
                        ),
                      );

                      Navigator.of(context).pop(true);
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    iconChild: const Icon(Icons.check),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}