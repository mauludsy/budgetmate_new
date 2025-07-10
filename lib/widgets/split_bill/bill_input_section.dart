// lib/widgets/split_bill/bill_input_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/split_bill_models.dart';

class BillInputSection extends StatelessWidget {
  final TextEditingController _totalBillController = TextEditingController();
  final TextEditingController _serviceChargeController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _additionalChargeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  BillInputSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final splitBillData = Provider.of<SplitBillData>(context, listen: false);

    // Inisialisasi controller dengan nilai yang ada di model
    _totalBillController.text = splitBillData.totalBillAmount > 0 ? splitBillData.totalBillAmount.toString() : '';
    _serviceChargeController.text = splitBillData.serviceChargePercentage > 0 ? splitBillData.serviceChargePercentage.toString() : '';
    _taxController.text = splitBillData.taxPercentage > 0 ? splitBillData.taxPercentage.toString() : '';
    _additionalChargeController.text = splitBillData.additionalChargesAmount > 0 ? splitBillData.additionalChargesAmount.toString() : '';
    _descriptionController.text = splitBillData.description;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Tagihan Utama',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Tagihan (Misal: Makan malam di Resto A)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => splitBillData.updateDescription(value),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _totalBillController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Tagihan Nota (Termasuk Pajak/SC jika sudah)',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                splitBillData.updateTotalBillAmount(double.tryParse(value) ?? 0.0);
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _serviceChargeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Service Charge (%)',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      splitBillData.updateServiceChargePercentage(double.tryParse(value) ?? 0.0);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _taxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Pajak (%)',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      splitBillData.updateTaxPercentage(double.tryParse(value) ?? 0.0);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _additionalChargeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Biaya Tambahan Lain (Rp)',
                prefixText: 'Rp ',
                hintText: 'Misal: Tip, Parkir',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                splitBillData.updateAdditionalChargesAmount(double.tryParse(value) ?? 0.0);
              },
            ),
          ],
        ),
      ),
    );
  }
}