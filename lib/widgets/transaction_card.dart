import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          transaction.isExpense ? Icons.arrow_upward : Icons.arrow_downward,
          color: transaction.isExpense ? Colors.red : Colors.green,
        ),
        title: Text(transaction.title),
        subtitle: Text('${transaction.date.toLocal()}'),
        trailing: Text(
          (transaction.isExpense ? '- ' : '+ ') +
              'Rp${transaction.amount.toStringAsFixed(0)}',
          style: TextStyle(
            color: transaction.isExpense ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
