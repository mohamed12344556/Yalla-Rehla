// pages/Transaction.dart
import 'package:flutter/material.dart';
import 'dart:async';

class Transaction {
  final String name;
  final double amount;
  final DateTime time;

  Transaction({required this.name, required this.amount, required this.time});
}

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Transaction> _transactions = [];
  bool _sortNewestFirst = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  // مؤقتًا 
  Future<void> fetchTransactions() async {
    List<Transaction> fetched = [
      Transaction(name: "Ahmed Mohamed", amount: 250.0, time: DateTime.now().subtract(const Duration(minutes: 10))),
      Transaction(name: "Sara Ali", amount: 150.0, time: DateTime.now().subtract(const Duration(hours: 1))),
      Transaction(name: "Mona Sameh", amount: 300.0, time: DateTime.now().subtract(const Duration(hours: 3))),
    ];

    setState(() {
      _transactions = fetched;
    });
  }
  void _sortTransactions() {
    setState(() {
      _sortNewestFirst = !_sortNewestFirst;
      _transactions.sort((a, b) => _sortNewestFirst
          ? b.time.compareTo(a.time)
          : a.time.compareTo(b.time));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: Icon(
              _sortNewestFirst ? Icons.arrow_downward : Icons.arrow_upward,
            ),
            tooltip: _sortNewestFirst ? "Sort: Newest First" : "Sort: Oldest First",
            onPressed: _sortTransactions,
          ),
        ],
      ),
      body: _transactions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Color.fromARGB(255, 101, 130, 105)),
                    title: Text(transaction.name),
                    subtitle: Text(
                      'Amount: ${transaction.amount.toStringAsFixed(2)} EGP\nTime: ${transaction.time.hour}:${transaction.time.minute.toString().padLeft(2, '0')}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
