import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final TextEditingController _totalBillController = TextEditingController();
  final TextEditingController _numPeopleController = TextEditingController();
  final List<TextEditingController> _extraItemsControllers = [];
  final List<double> _extraItemsAmounts = [];

  double _totalBill = 0.0;
  int _numPeople = 1;
  double _amountPerPerson = 0.0;
  double _totalExtraItems = 0.0;
  String _splitResult = '';

  @override
  void initState() {
    super.initState();
    _totalBillController.addListener(_calculateSplit);
    _numPeopleController.addListener(_calculateSplit);
  }

  @override
  void dispose() {
    _totalBillController.dispose();
    _numPeopleController.dispose();
    for (var controller in _extraItemsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _calculateSplit() {
    setState(() {
      _totalBill = double.tryParse(_totalBillController.text) ?? 0.0;
      _numPeople = int.tryParse(_numPeopleController.text) ?? 1;
      if (_numPeople < 1) _numPeople = 1;

      _totalExtraItems = _extraItemsAmounts.fold(0.0, (sum, item) => sum + item);

      double billAfterExtra = _totalBill - _totalExtraItems;
      if (_numPeople > 0) {
        _amountPerPerson = billAfterExtra / _numPeople;
      } else {
        _amountPerPerson = 0.0;
      }

      if (_totalBill > 0 && _numPeople > 0) {
        _splitResult = 'Setiap orang membayar: Rp${NumberFormat('#,##0', 'id_ID').format(_amountPerPerson.abs())}';
        if (_totalExtraItems > 0) {
          _splitResult += '\n(Total biaya tambahan: Rp${NumberFormat('#,##0', 'id_ID').format(_totalExtraItems)})';
        }
      } else {
        _splitResult = 'Masukkan total tagihan dan jumlah orang.';
      }
    });
  }

  void _addExtraItem() {
    setState(() {
      final controller = TextEditingController();
      _extraItemsControllers.add(controller);
      _extraItemsAmounts.add(0.0); // Initialize with 0
      controller.addListener(() {
        _updateExtraItemAmount(controller, _extraItemsControllers.indexOf(controller));
      });
    });
  }

  void _removeExtraItem(int index) {
    setState(() {
      _extraItemsControllers[index].dispose();
      _extraItemsControllers.removeAt(index);
      _extraItemsAmounts.removeAt(index);
      _calculateSplit();
    });
  }

  void _updateExtraItemAmount(TextEditingController controller, int index) {
    setState(() {
      _extraItemsAmounts[index] = double.tryParse(controller.text) ?? 0.0;
      _calculateSplit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Split Bill', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _totalBillController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Tagihan (Rp)',
                border: OutlineInputBorder(),
                prefixText: 'Rp',
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _numPeopleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Orang',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            Text(
              'Biaya Tambahan (Contoh: Pajak, Servis, Makanan Individu):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _extraItemsControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _extraItemsControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Biaya Item ${index + 1} (Rp)',
                            border: const OutlineInputBorder(),
                            prefixText: 'Rp',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeExtraItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addExtraItem,
                icon: const Icon(Icons.add_circle),
                label: const Text('Tambah Item Biaya Tambahan'),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Split:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Tagihan: Rp${NumberFormat('#,##0', 'id_ID').format(_totalBill)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Total Biaya Tambahan: Rp${NumberFormat('#,##0', 'id_ID').format(_totalExtraItems)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Tagihan Bersih (untuk dibagi rata): Rp${NumberFormat('#,##0', 'id_ID').format(_totalBill - _totalExtraItems)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _splitResult,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}