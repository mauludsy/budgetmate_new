// lib/models/category.dart

import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final MaterialColor color; // <--- Perubahan di sini: dari Color menjadi MaterialColor

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Daftar kategori dummy untuk digunakan di aplikasi
final List<Category> dummyCategories = [
  // Menggunakan base MaterialColor (misal: Colors.orange) yang memiliki metode shade
  Category(id: 'c1', name: 'Makan', icon: Icons.fastfood, color: Colors.orange),
  Category(id: 'c2', name: 'Minum', icon: Icons.local_cafe, color: Colors.brown),
  Category(id: 'c3', name: 'Telepon', icon: Icons.phone, color: Colors.blue),
  Category(id: 'c4', name: 'Hiburan', icon: Icons.movie, color: Colors.purple),
  Category(id: 'c5', name: 'Laundry', icon: Icons.local_laundry_service, color: Colors.teal),
  Category(id: 'c6', name: 'Belanja', icon: Icons.shopping_bag, color: Colors.pink),
  Category(id: 'c7', name: 'Buah', icon: Icons.apple, color: Colors.red),
  Category(id: 'c8', name: 'Sayur', icon: Icons.eco, color: Colors.green),
  Category(id: 'c9', name: 'Makeup', icon: Icons.face, color: Colors.deepPurple),
  Category(id: 'c10', name: 'Sehari-hari', icon: Icons.home, color: Colors.grey),
  Category(id: 'c11', name: 'Camilan', icon: Icons.cookie, color: Colors.yellow),
  Category(id: 'c12', name: 'Gaji', icon: Icons.payments, color: Colors.green),
  Category(id: 'c13', name: 'Bonus', icon: Icons.card_giftcard, color: Colors.blue),
  Category(id: 'c14', name: 'Lain-lain', icon: Icons.more_horiz, color: Colors.grey),
];
