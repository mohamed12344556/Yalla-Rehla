import 'package:flutter/material.dart';

import 'ElectricPaymentPage.dart';

class ChooseCardPage extends StatefulWidget {
  const ChooseCardPage({super.key});

  @override
  State<ChooseCardPage> createState() => _ChooseCardPageState();
}

class _ChooseCardPageState extends State<ChooseCardPage> {
  List<Map<String, dynamic>> cards = [];
  int selectedCardIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  Future<void> fetchCards() async {
    await Future.delayed(const Duration(seconds: 2));
    cards = [
      {'title': 'Business card', 'number': '4325112212341122'},
      {'title': 'Wise regular', 'number': '9876554433214444'},
    ];
    setState(() {
      isLoading = false;
    });
  }

  String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return "****";
    return '**** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Card"),
        leading: const BackButton(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                ...List.generate(cards.length, (index) {
                  final card = cards[index];
                  return ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: Text(card['title']),
                    subtitle: Text(maskCardNumber(card['number'])),
                    trailing: Icon(
                      selectedCardIndex == index
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                    ),
                    onTap: () {
                      setState(() {
                        selectedCardIndex = index;
                      });
                    },
                  );
                }),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCardIndex >= 0) {
                      final selectedCard = cards[selectedCardIndex];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ElectricPaymentPage(
                            name: 'Customer Name',
                            cardNumber: selectedCard['number'],
                            provider: 'Provider Name',
                            internetFee: 100.0,
                            tax: 10.0,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text("PROCEED"),
                ),
              ],
            ),
    );
  }
}
