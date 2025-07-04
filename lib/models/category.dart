import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final MaterialColor color;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

final List<Category> dummyCategories = [
  Category(id: 'c1', name: 'Makan', icon: Icons.fastfood, color: Colors.orange),
  Category(id: 'c2', name: 'Minum', icon: Icons.local_cafe, color: Colors.blue),
  Category(id: 'c3', name: 'Telepon', icon: Icons.phone_android, color: Colors.purple),
  Category(id: 'c4', name: 'Hiburan', icon: Icons.movie, color: Colors.red),
  Category(id: 'c7', name: 'Belanja', icon: Icons.shopping_basket, color: Colors.pink),
  Category(id: 'c8', name: 'Buah', icon: Icons.apple, color: Colors.lime),
  Category(id: 'c9', name: 'Sayur', icon: Icons.local_florist, color: Colors.lightGreen),
  Category(id: 'c10', name: 'Makeup', icon: Icons.face, color: Colors.deepPurple),
  Category(id: 'c11', name: 'Sehari-hari', icon: Icons.event_note, color: Colors.brown),
  Category(id: 'c12', name: 'Camilan', icon: Icons.cookie, color: Colors.amber),
  Category(id: 'c14', name: 'Laundry', icon: Icons.local_laundry_service, color: Colors.cyan),
  Category(id: 'c13', name: 'Lain-lain', icon: Icons.category, color: Colors.grey),

  Category(id: 'c5', name: 'Gaji', icon: Icons.account_balance_wallet, color: Colors.green),
  Category(id: 'c6', name: 'Keuntungan', icon: Icons.monetization_on, color: Colors.teal),
  Category(id: 'c15', name: 'Bonus', icon: Icons.star, color: Colors.deepOrange),
];