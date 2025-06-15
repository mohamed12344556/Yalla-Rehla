import 'package:flutter/material.dart';

import 'HomePage.dart';

class ElectricPaymentPage extends StatelessWidget {
  final String name;
  final String cardNumber;
  final String provider;
  final double internetFee;
  final double tax;

  const ElectricPaymentPage({
    super.key,
    required this.name,
    required this.cardNumber,
    required this.provider,
    required this.internetFee,
    required this.tax,
  });

  String getMaskedCard(String cardNumber) {
    final last4 = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $last4';
  }

  @override
  Widget build(BuildContext context) {
    final total = internetFee + tax;

    return Scaffold(
      appBar: AppBar(title: const Text("Electric Payment")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow("Name:", name),
            _buildRow("Card:", getMaskedCard(cardNumber)),
            _buildRow("Provider:", provider),
            const SizedBox(height: 24),

            _buildRow("Internet Fee:", "\$${internetFee.toStringAsFixed(2)}"),
            _buildRow("Tax:", "\$${tax.toStringAsFixed(2)}"),
            _buildRow(
              "Total:",
              "\$${total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
