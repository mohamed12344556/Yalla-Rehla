import 'package:flutter/material.dart';

import 'ChooseCardPage.dart';

class PaymentDetailsPage extends StatelessWidget {
  final String customerId;
  final String subscriptionCode;
  final String providerNumber;
  final String date;
  final String time;
  final String status;
  final double fee;
  final double tax;
  final String provider;

  const PaymentDetailsPage({
    super.key,
    required this.customerId,
    required this.subscriptionCode,
    required this.providerNumber,
    required this.date,
    required this.time,
    required this.status,
    required this.fee,
    required this.tax,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final double total = fee + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildInfoRow("Customer ID", customerId),
          _buildInfoRow("Subscription Code", subscriptionCode),
          _buildInfoRow("Provider Number", providerNumber),
          _buildInfoRow("Date", date),
          _buildInfoRow("Time", time),
          _buildInfoRow("Status", status),
          _buildInfoRow("Provider", provider),
          _buildInfoRow("Fee", "${fee.toStringAsFixed(2)} EGP"),
          _buildInfoRow("Tax", "${tax.toStringAsFixed(2)} EGP"),
          _buildInfoRow("Total", "${total.toStringAsFixed(2)} EGP"),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseCardPage(), 
                ),
              );
            },
            child: const Text("Confirm Payment"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}


