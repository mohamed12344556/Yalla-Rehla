// pages/CardDetailsPage.dart
import 'package:flutter/material.dart';
import 'CardDetailViewPage.dart';

class CardDetailsPage extends StatelessWidget {
  const CardDetailsPage({super.key, required List userCards});

  final List<Map<String, dynamic>> userCards = const [
    {
      'type': 'Visa',
      'last4': '1234',
      'number': '4111111111111234',
      'holder': 'Sarah Ali',
      'expiry': '12/26',
      'validFrom': '12/23',
    },
    {
      'type': 'MasterCard',
      'last4': '5678',
      'number': '5500000000005678',
      'holder': 'Mona Khaled',
      'expiry': '08/25',
      'validFrom': '08/22',
    },
    {
      'type': 'Amex',
      'last4': '9876',
      'number': '3714496353989876',
      'holder': 'Yasmin Mohamed',
      'expiry': '03/27',
      'validFrom': '03/24',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Details"),
        backgroundColor:  const Color.fromARGB(255, 101, 130, 105),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: userCards.length,
          itemBuilder: (context, index) {
            final card = userCards[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.credit_card, color:  Color.fromARGB(255, 101, 130, 105)),
                title: Text("Card Type: ${card['type']}"),
                subtitle: Text("Card Holder: ${card['holder']}"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardDetailViewPage(card: card),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
