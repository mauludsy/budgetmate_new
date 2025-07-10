// lib/widgets/split_bill/item_list_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // Untuk UUID
import '../../models/split_bill_models.dart';
import 'item_allocation_dialog.dart'; // <<< PASTIKAN INI DIIMPOR

final _uuid = Uuid();

class ItemListSection extends StatefulWidget {
  const ItemListSection({Key? key}) : super(key: key);

  @override
  State<ItemListSection> createState() => _ItemListSectionState();
}

class _ItemListSectionState extends State<ItemListSection> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();

  void _addItem(BuildContext context) {
    final String name = _itemNameController.text.trim();
    final double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final int quantity = int.tryParse(_itemQuantityController.text) ?? 1;

    if (name.isEmpty || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama item dan harga harus diisi dengan benar.')),
      );
      return;
    }

    final newItem = BillItem(
      id: _uuid.v4(),
      name: name,
      price: price,
      quantity: quantity,
    );

    Provider.of<SplitBillData>(context, listen: false).addItem(newItem);

    _itemNameController.clear();
    _itemPriceController.clear();
    _itemQuantityController.clear();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemPriceController.dispose();
    _itemQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Item',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga per Unit',
                      prefixText: 'Rp ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _itemQuantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
                      hintText: '1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () => _addItem(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Tambah Item', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF67B00C),
                minimumSize: const Size.fromHeight(40), // Lebar penuh
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            // START OF THE FIX: The Consumer should wrap the ListView.builder
            Consumer<SplitBillData>(
              builder: (context, splitBillData, child) {
                if (splitBillData.items.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Belum ada item ditambahkan.'),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: splitBillData.items.length,
                  itemBuilder: (context, index) {
                    final item = splitBillData.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    '${item.quantity} x Rp ${item.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                  // Tampilkan siapa yang mengkonsumsi
                                  if (item.consumedByParticipantIds.isNotEmpty && splitBillData.participants.isNotEmpty)
                                    Text(
                                      'Oleh: ${item.consumedByParticipantIds.map((id) {
                                        try {
                                          return splitBillData.participants.firstWhere((p) => p.id == id).name;
                                        } catch (e) {
                                          // Handle case where participant might have been removed
                                          return 'Unknown';
                                        }
                                      }).join(', ')}',
                                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                                    )
                                  else if (splitBillData.participants.isEmpty)
                                    const Text(
                                      'Tambahkan anggota untuk alokasi',
                                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.orange),
                                    )
                                  else
                                    const Text(
                                      'Belum dialokasikan',
                                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${item.subtotal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.group_add, color: Colors.blue), // Ikon alokasi
                              onPressed: () {
                                if (splitBillData.participants.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Tambahkan anggota terlebih dahulu untuk mengalokasikan item.')),
                                  );
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (context) => ItemAllocationDialog(
                                    item: item,
                                    participants: splitBillData.participants,
                                    onAllocate: (updatedItem) {
                                      splitBillData.updateItem(updatedItem); // Update item di model
                                    },
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => splitBillData.removeItem(item.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // END OF THE FIX
          ],
        ),
      ),
    );
  }
}