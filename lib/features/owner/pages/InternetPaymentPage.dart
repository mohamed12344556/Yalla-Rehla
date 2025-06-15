import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'PaymentDetailsPage.dart';

class InternetPaymentPage extends StatefulWidget {
  const InternetPaymentPage({super.key});

  @override
  State<InternetPaymentPage> createState() => _InternetPaymentPageState();
}

class _InternetPaymentPageState extends State<InternetPaymentPage> {
  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _subscriptionCodeController = TextEditingController();
  final TextEditingController _providerNumberController = TextEditingController();

  bool get isButtonEnabled =>
      _customerIdController.text.isNotEmpty &&
      _subscriptionCodeController.text.isNotEmpty &&
      _providerNumberController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _customerIdController.addListener(_updateState);
    _subscriptionCodeController.addListener(_updateState);
    _providerNumberController.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  @override
  void dispose() {
    _customerIdController.dispose();
    _subscriptionCodeController.dispose();
    _providerNumberController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchPaymentDetails() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'status': 'active',
      'fee': 20.0,
      'tax': 3.5,
      'provider': 'WE',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internet"),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          TextField(
            controller: _customerIdController,
            decoration: const InputDecoration(
              labelText: "Customer ID",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _subscriptionCodeController,
            decoration: const InputDecoration(
              labelText: "Subscription Code",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _providerNumberController,
            decoration: const InputDecoration(
              labelText: "Provider Number",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isButtonEnabled
                ? () async {
                    final data = await fetchPaymentDetails();
                    final now = DateTime.now();
                    final formattedDate = DateFormat('dd/MM/yyyy').format(now);
                    final formattedTime = DateFormat('HH:mm').format(now);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentDetailsPage(
                          customerId: _customerIdController.text,
                          subscriptionCode: _subscriptionCodeController.text,
                          providerNumber: _providerNumberController.text,
                          date: formattedDate,
                          time: formattedTime,
                          status: data['status'],
                          fee: data['fee'],
                          tax: data['tax'],
                          provider: data['provider'],
                        ),
                      ),
                    );
                  }
                : null,
            child: const Text("CONTINUE"),
          ),
        ],
      ),
    );
  }
}
