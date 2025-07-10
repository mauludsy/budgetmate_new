// lib/widgets/split_bill/participant_list_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/split_bill_models.dart';

final _uuid = Uuid();

class ParticipantListSection extends StatefulWidget {
  const ParticipantListSection({Key? key}) : super(key: key);

  @override
  State<ParticipantListSection> createState() => _ParticipantListSectionState();
}

class _ParticipantListSectionState extends State<ParticipantListSection> {
  final TextEditingController _participantNameController = TextEditingController();

  void _addParticipant(BuildContext context) {
    final String name = _participantNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama anggota tidak boleh kosong.')),
      );
      return;
    }

    final newParticipant = BillParticipant(id: _uuid.v4(), name: name);
    Provider.of<SplitBillData>(context, listen: false).addParticipant(newParticipant);
    _participantNameController.clear();
  }

  @override
  void dispose() {
    _participantNameController.dispose();
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
              'Daftar Anggota',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _participantNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Anggota',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addParticipant(context), // Bisa add dengan enter
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () => _addParticipant(context),
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('Tambah Anggota', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF67B00C),
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<SplitBillData>(
              builder: (context, splitBillData, child) {
                if (splitBillData.participants.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Belum ada anggota ditambahkan.'),
                    ),
                  );
                }
                return Column(
                  children: splitBillData.participants.map((participant) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                participant.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => splitBillData.removeParticipant(participant.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}