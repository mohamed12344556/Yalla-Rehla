// pages/CardDetailViewPage.dart
import 'package:flutter/material.dart';

class CardDetailViewPage extends StatelessWidget {
  final Map<String, dynamic> card;

  const CardDetailViewPage({super.key, required this.card});

  String maskCardNumber(String cardNumber) {
    if (cardNumber.length >= 4) {
      String last4 = cardNumber.substring(cardNumber.length - 4);
      return '**** **** **** $last4';
    }
    return cardNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Info"),
        backgroundColor:  const Color.fromARGB(255, 101, 130, 105),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text("Card Number", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text("Valid From", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text("Good Thru", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(card['holder'] ?? 'N/A', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    Text(maskCardNumber(card['number'] ?? '0000000000000000'),
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    Text(card['validFrom'] ?? 'N/A', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    Text(card['expiry'] ?? 'N/A', style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),

            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Are you sure you want to delete this card?",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context); 
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Card deleted")),
                                );
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text("Delete"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  "Delete Card",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
