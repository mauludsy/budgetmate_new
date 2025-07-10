// lib/widgets/split_bill/item_allocation_dialog.dart
import 'package:flutter/material.dart';
import '../../models/split_bill_models.dart';

class ItemAllocationDialog extends StatefulWidget {
  final BillItem item;
  final List<BillParticipant> participants;
  final Function(BillItem) onAllocate;

  const ItemAllocationDialog({
    Key? key,
    required this.item,
    required this.participants,
    required this.onAllocate,
  }) : super(key: key);

  @override
  State<ItemAllocationDialog> createState() => _ItemAllocationDialogState();
}

class _ItemAllocationDialogState extends State<ItemAllocationDialog> {
  late BillItem _currentItem; // Salinan item untuk dimodifikasi

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item.copyWith(); // Buat salinan agar tidak mengubah objek asli secara langsung
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alokasikan "${_currentItem.name}"'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.participants.map((participant) {
            return CheckboxListTile(
              title: Text(participant.name),
              value: _currentItem.consumedByParticipantIds.contains(participant.id),
              onChanged: (bool? isChecked) {
                setState(() {
                  if (isChecked == true) {
                    _currentItem.consumedByParticipantIds.add(participant.id);
                  } else {
                    _currentItem.consumedByParticipantIds.remove(participant.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAllocate(_currentItem); // Panggil callback dengan item yang sudah dimodifikasi
            Navigator.of(context).pop();
          },
          child: const Text('Simpan Alokasi'),
        ),
      ],
    );
  }
}