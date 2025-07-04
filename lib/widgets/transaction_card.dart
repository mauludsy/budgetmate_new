import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_mate_app/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: transaction.category.color.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            transaction.category.icon,
            color: transaction.category.color.shade800,
            size: 30,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${transaction.category.name} | ${DateFormat('dd MMMんですよ').format(transaction.date)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Text(
          '${transaction.isExpense ? '- ' : '+ '}Rp${NumberFormat('#,##0', 'id_ID').format(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Keep this one for bolding the amount
            fontSize: 16,
            color: transaction.isExpense ? Colors.red : Colors.green,
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Detail transaksi ${transaction.title}')),
          );
        },
      ),
    );
  }
}