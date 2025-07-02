// lib/models/transaction.dart

import 'package:flutter/material.dart'; // Untuk IconData
import 'package:budget_mate_app/models/category.dart'; // Import model Category

class Transaction {
  final String id; // ID unik
  final String title; // Judul transaksi
  final double amount; // Jumlah uang
  final DateTime date; // Tanggal transaksi
  final bool isExpense; // true jika pengeluaran, false jika pemasukan
  final Category category; // Kategori transaksi

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.category,
  });
}
