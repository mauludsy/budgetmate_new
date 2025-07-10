// lib/models/split_bill_models.dart
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart'; // <<< TAMBAHKAN INI

final uuid = Uuid();

class BillItem {
  final String id; // Unique ID for each item
  String name;
  double price;
  int quantity;

  // List of participant IDs who consumed this item
  // If empty, this item will be part of unallocated portion (e.g., tax/service) or split evenly.
  List<String> consumedByParticipantIds;

  BillItem({
    String? id,
    required this.name,
    required this.price,
    this.quantity = 1,
    List<String>? consumedByParticipantIds,
  }) :  id = id ?? uuid.v4(),
        consumedByParticipantIds = consumedByParticipantIds ?? [];

  double get subtotal => price * quantity;

  // Utility to create a copy for state updates
  BillItem copyWith({
    String? name,
    double? price,
    int? quantity,
    List<String>? consumedByParticipantIds,
  }) {
    return BillItem(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      consumedByParticipantIds: consumedByParticipantIds ?? this.consumedByParticipantIds,
    );
  }
}

class BillParticipant {
  final String id; // Unique ID for each participant
  String name;
  double amountToPay; // Calculated amount this participant needs to pay

  BillParticipant({String? id, required this.name, this.amountToPay = 0.0})
      : id = id ?? uuid.v4();

  // Utility to create a copy
  BillParticipant copyWith({
    String? name,
    double? amountToPay,
  }) {
    return BillParticipant(
      id: id,
      name: name ?? this.name,
      amountToPay: amountToPay ?? this.amountToPay,
    );
  }
}

// Model untuk menyimpan semua data split bill
class SplitBillData extends ChangeNotifier { // Baris 65
  double totalBillAmount; // Total tagihan nota
  double serviceChargePercentage; // Contoh: 10%
  double taxPercentage; // Contoh: 11%
  List<BillItem> items;
  List<BillParticipant> participants;
  double additionalChargesAmount; // Untuk biaya tambahan lain (misal: tip, parkir)
  String description; // Deskripsi bill

  SplitBillData({
    this.totalBillAmount = 0.0,
    this.serviceChargePercentage = 0.0,
    this.taxPercentage = 0.0,
    List<BillItem>? items,
    List<BillParticipant>? participants,
    this.additionalChargesAmount = 0.0,
    this.description = '',
  })  : items = items ?? [],
        participants = participants ?? [];

  // Update methods (ini penting karena SplitBillData adalah ChangeNotifier)
  void updateTotalBillAmount(double amount) {
    totalBillAmount = amount;
    notifyListeners();
  }

  void updateServiceChargePercentage(double percentage) {
    serviceChargePercentage = percentage;
    notifyListeners();
  }

  void updateTaxPercentage(double percentage) {
    taxPercentage = percentage;
    notifyListeners();
  }

  void updateAdditionalChargesAmount(double amount) {
    additionalChargesAmount = amount;
    notifyListeners();
  }

  void updateDescription(String desc) {
    description = desc;
    notifyListeners();
  }

  void addItem(BillItem item) {
    items.add(item);
    notifyListeners();
  }

  void updateItem(BillItem updatedItem) {
    final index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      items[index] = updatedItem;
      // Perhatikan: Karena BillItem adalah immutable (final fields),
      // kita harus membuat salinan BillItem yang baru jika ingin mengubah consumedByParticipantIds
      // meskipun di sini kita mengedit consumedByParticipantIds langsung.
      // Namun, `copyWith` sudah membantu kita mengelola itu.
      // Pastikan `consumedByParticipantIds` juga di-update jika ada perubahan alokasi.
      notifyListeners(); // Tetap panggil notifyListeners untuk merefresh UI
    }
  }

  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void addParticipant(BillParticipant participant) {
    participants.add(participant);
    notifyListeners();
  }

  void updateParticipant(BillParticipant updatedParticipant) {
    final index = participants.indexWhere((p) => p.id == updatedParticipant.id);
    if (index != -1) {
      participants[index] = updatedParticipant;
      notifyListeners();
    }
  }

  void removeParticipant(String participantId) {
    // Juga hapus alokasi item jika peserta dihapus
    for (var item in items) {
      item.consumedByParticipantIds.remove(participantId);
    }
    participants.removeWhere((p) => p.id == participantId);
    notifyListeners();
  }

  // Metode untuk mengatur siapa yang mengkonsumsi item
  void toggleItemConsumption(String itemId, String participantId) {
    final itemIndex = items.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      final item = items[itemIndex];
      // Karena List<String> itu reference, kita bisa langsung modify.
      // Tapi untuk memastikan notifyListeners terpicu secara konsisten,
      // lebih baik membuat salinan list baru atau menggunakan copyWith di BillItem
      if (item.consumedByParticipantIds.contains(participantId)) {
        item.consumedByParticipantIds.remove(participantId);
      } else {
        item.consumedByParticipantIds.add(participantId);
      }
      // Kita panggil updateItem untuk memastikan perubahan pada item di list juga memicu notifyListeners
      updateItem(item); // Ini akan memicu notifyListeners
    }
  }


  // Metode untuk menghitung hasil split (akan kita implementasikan)
  void calculateSplit() {
    if (participants.isEmpty) {
      for (var p in participants) { // Masih ada participant object tapi kosong
        p.amountToPay = 0.0;
      }
      notifyListeners();
      return;
    }

    // Inisialisasi jumlah yang harus dibayar setiap peserta
    Map<String, double> participantPayments = {
      for (var p in participants) p.id: 0.0
    };

    double totalItemsCost = 0.0; // Ini yang sebelumnya unused
    // --- Langkah 1: Alokasikan biaya item yang sudah dipilih ---
    for (var item in items) {
      totalItemsCost += item.subtotal; // Sekarang digunakan
      if (item.consumedByParticipantIds.isNotEmpty) {
        double amountPerPayer = item.subtotal / item.consumedByParticipantIds.length;
        for (var pId in item.consumedByParticipantIds) {
          participantPayments[pId] = (participantPayments[pId] ?? 0.0) + amountPerPayer;
        }
      }
    }

    // --- Langkah 2: Hitung Total Pajak dan Service Charge ---
    double calculatedServiceCharge = totalBillAmount * (serviceChargePercentage / 100);
    double calculatedTax = totalBillAmount * (taxPercentage / 100);
    double totalAdditionalCalculatedCharges = calculatedServiceCharge + calculatedTax + additionalChargesAmount; // Sekarang digunakan


    // --- Langkah 3: Hitung total biaya yang sudah dialokasikan dari item ---
    double currentAllocatedAmountFromItems = participantPayments.values.fold(0.0, (sum, amount) => sum + amount);


    // --- Langkah 4: Distribusikan sisa (unallocated amount) secara merata atau sesuai logika lain ---
    // Logika yang lebih tepat: Hitung total semua yang harus dibagi: total item cost + pajak + service charge + biaya tambahan
    // Lalu, jika total item yang dialokasikan tidak sama dengan total item cost, sisa item yang belum teralokasi
    // akan ditambah ke biaya tambahan, lalu dibagi rata.
    // ATAU
    // Kita asumsikan `totalBillAmount` adalah total keseluruhan yang sudah mencakup semuanya.
    // Kita alokasikan item yang spesifik. Sisa dari `totalBillAmount` yang tidak dialokasikan oleh item spesifik
    // akan dibagi rata ke semua peserta. Ini adalah interpretasi yang lebih kuat untuk "total tagihan nota".

    double remainingAmountToDistribute = totalBillAmount; // Mulai dari total bill yang harus dibagi

    // Kurangi bagian yang sudah dialokasikan dari item-item
    remainingAmountToDistribute -= currentAllocatedAmountFromItems;

    // Tambahkan biaya tambahan yang harus dibagi rata (jika asumsinya pajak/SC dibagi rata)
    // Jika totalBillAmount sudah termasuk pajak/SC, maka ini tidak perlu ditambah lagi.
    // Kalau belum, maka:
    // remainingAmountToDistribute += totalAdditionalCalculatedCharges; // Hati-hati dengan double counting!

    // Asumsi saat ini: `totalBillAmount` sudah termasuk semua.
    // Jika ada sisa `remainingAmountToDistribute` positif setelah mengurangi item yang dialokasikan,
    // maka sisa ini adalah bagian yang belum teralokasi, termasuk pajak/SC yang tersembunyi, dll.
    // Bagikan sisa ini secara merata ke semua peserta.
    if (remainingAmountToDistribute > 0 && participants.isNotEmpty) {
        double unallocatedPerPerson = remainingAmountToDistribute / participants.length;
        for (var p in participants) {
            participantPayments[p.id] = (participantPayments[p.id] ?? 0.0) + unallocatedPerPerson;
        }
    }

    // --- Langkah 5: Update jumlah akhir yang harus dibayar oleh setiap peserta ---
    for (var p in participants) {
      p.amountToPay = participantPayments[p.id] ?? 0.0;
    }
    notifyListeners();
  }
}