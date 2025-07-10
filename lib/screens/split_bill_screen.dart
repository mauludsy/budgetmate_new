// lib/screens/split_bill_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Pastikan package provider sudah ada di pubspec.yaml
import '../models/split_bill_models.dart';
import '../widgets/split_bill/bill_input_section.dart';
import '../widgets/split_bill/item_list_section.dart';
import '../widgets/split_bill/participant_list_section.dart';
import '../widgets/split_bill/summary_result_section.dart';

class SplitBillScreen extends StatelessWidget {
  const SplitBillScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplitBillData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Split Bill Canggih'),
          backgroundColor: const Color(0xFF67B00C),
        ),
        body: Consumer<SplitBillData>(
          builder: (context, splitBillData, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section 1: Input Detail Bill (Total, Tax, Service Charge, Additional)
                  BillInputSection(),
                  const SizedBox(height: 20),

                  // Section 2: Input & List Items
                  ItemListSection(),
                  const SizedBox(height: 20),

                  // Section 3: Input & List Participants
                  ParticipantListSection(),
                  const SizedBox(height: 20),

                  // Section 4: Tombol Hitung dan Hasil
                  ElevatedButton(
                    onPressed: () {
                      splitBillData.calculateSplit();
                      // Tampilkan snackbar atau navigasi ke halaman hasil
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pembagian dihitung!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD767),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Hitung Pembagian',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section 5: Hasil Pembagian
                  SummaryResultSection(),
                  const SizedBox(height: 50), // Ruang untuk FAB di masa depan
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}