import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Chat_with_admin_Page copy.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  final String supportPhone = 'tel:+123456';

  void _launchCaller(BuildContext context) async {
    final Uri launchUri = Uri.parse(supportPhone);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open the dialer.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: const Color.fromARGB(255, 101, 130, 105),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            const Icon(Icons.support_agent, size: 100, color: Color.fromARGB(255, 207, 221, 192)),
            const SizedBox(height: 20),

            const Text(
              "We're Here to Help!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            const Text(
              "Our support team is available 24/7 to assist you with anything you need.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Chat_with_admin_Page()),
                  );
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text("Chat with Us"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 101, 130, 105),
                    textStyle: const TextStyle(fontSize: 16),
                    ),
                    ),
                    ),
                    const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchCaller(context),
                icon: const Icon(Icons.call),
                label: const Text("Call Us"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color.fromARGB(255, 101, 130, 105),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
