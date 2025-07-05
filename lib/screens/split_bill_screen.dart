// lib/screens/split_bill_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final _totalBillController = TextEditingController();
  final _numPeopleController = TextEditingController();
  double _billPerPerson = 0.0;
  final oCcy = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  void _calculateSplit() {
    double totalBill = double.tryParse(_totalBillController.text) ?? 0.0;
    int numPeople = int.tryParse(_numPeopleController.text) ?? 1;

    if (numPeople > 0) {
      setState(() {
        _billPerPerson = totalBill / numPeople;
      });
    } else {
      setState(() {
        _billPerPerson = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah orang harus lebih dari 0')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Hitung Bagi Tagihan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _totalBillController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Tagihan (Rp)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              onChanged: (value) => _calculateSplit(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _numPeopleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Orang',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
              onChanged: (value) => _calculateSplit(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _calculateSplit,
              icon: const Icon(Icons.calculate),
              label: const Text(
                'Hitung',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Tagihan per Orang:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      oCcy.format(_billPerPerson),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}