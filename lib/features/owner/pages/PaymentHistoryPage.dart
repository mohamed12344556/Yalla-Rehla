import 'package:flutter/material.dart';

import 'ElectricPaymentPage.dart';

class PaymentHistoryPage extends StatelessWidget {
  PaymentHistoryPage({super.key});

  // مؤقتا
  final List<Map<String, dynamic>> paymentHistory = [
    {
      'company': 'Capital Electric',
      'date': 'October 2025',
      'amount': 30.0,
      'isPaid': true,
    },
    {
      'company': 'Capital Telecom',
      'date': 'September 2025',
      'amount': 20.0,
      'isPaid': false,
    },
    {
      'company': 'Capital Electric',
      'date': 'July 2025',
      'amount': 50.0,
      'isPaid': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment History")),
      body: Expanded(
        child: paymentHistory.isEmpty
            ? const Center(child: Text("No payments yet. Add a new one!"))
            : ListView.builder(
                itemCount: paymentHistory.length,
                itemBuilder: (context, index) {
                  final payment = paymentHistory[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ElectricPaymentPage(
                            name: payment['company'] ?? '',
                            cardNumber: '**** **** **** 1122',
                            provider: payment['company'] ?? '',
                            internetFee: payment['amount'] ?? 0.0,
                            tax: 0.0,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payment['company'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(payment['date'] ?? ''),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$${payment['amount']?.toStringAsFixed(2) ?? '0.00'}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 101, 130, 105),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  payment['isPaid'] == true
                                      ? 'Paid'
                                      : 'Pending',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: payment['isPaid'] == true
                                        ? const Color.fromARGB(
                                            255,
                                            101,
                                            130,
                                            105,
                                          )
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
