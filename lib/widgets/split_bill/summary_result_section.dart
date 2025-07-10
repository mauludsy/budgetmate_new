// lib/widgets/split_bill/summary_result_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/split_bill_models.dart';

class SummaryResultSection extends StatelessWidget {
  const SummaryResultSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SplitBillData>(
      builder: (context, splitBillData, child) {
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hasil Pembagian',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                // Ringkasan Tagihan Total
                _buildSummaryRow(
                  'Total Tagihan Nota',
                  splitBillData.totalBillAmount,
                  Colors.black87,
                ),
                _buildSummaryRow(
                  'Service Charge (${splitBillData.serviceChargePercentage.toStringAsFixed(0)}%)',
                  splitBillData.totalBillAmount * (splitBillData.serviceChargePercentage / 100),
                  Colors.black54,
                ),
                _buildSummaryRow(
                  'Pajak (${splitBillData.taxPercentage.toStringAsFixed(0)}%)',
                  splitBillData.totalBillAmount * (splitBillData.taxPercentage / 100),
                  Colors.black54,
                ),
                 _buildSummaryRow(
                  'Biaya Tambahan Lain',
                  splitBillData.additionalChargesAmount,
                  Colors.black54,
                ),
                const Divider(),
                 _buildSummaryRow(
                  'TOTAL YANG DIALOKASIKAN',
                  splitBillData.participants.fold(0.0, (sum, p) => sum + p.amountToPay),
                  Colors.green.shade700,
                  isBold: true,
                ),
                const SizedBox(height: 20),
                // Hasil per Anggota
                if (splitBillData.participants.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Pembayaran Per Anggota:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      ...splitBillData.participants.map((participant) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                participant.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Rp ${participant.amountToPay.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF67B00C)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  )
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Hitung pembagian terlebih dahulu.'),
                    ),
                  ),
                // TODO: Tambahkan tombol "Simpan Transaksi" atau "Bagikan Hasil"
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, double amount, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}