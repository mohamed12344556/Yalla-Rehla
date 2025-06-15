import 'package:flutter/material.dart';

import 'ChangePasswordPage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class TypeCodePage extends StatefulWidget {
  final String email;

  const TypeCodePage({super.key, required this.email});

  @override
  State<TypeCodePage> createState() => _TypeCodePageState();
}

class _TypeCodePageState extends State<TypeCodePage> {
  final TextEditingController codeController = TextEditingController();
  String generatedCode = "123456";
  bool isCodeEntered = false;

  @override
  void initState() {
    super.initState();
    codeController.addListener(() {
      setState(() {
        isCodeEntered = codeController.text.trim().isNotEmpty;
      });
    });
  }

  void resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Verification code resent to your email")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter the code 🔑", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
          Row(
  children: [
    Expanded(
      flex: 3,
      child: SizedBox(
        height: 48,
        width: 200, 
        child: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: "Code",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    ),
    SizedBox(width: 16), 
    SizedBox(
      width: 100,
      height: 48, 
      child: ElevatedButton(
        onPressed: resendCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 101, 130, 105),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text("Resend", style: TextStyle(color: Colors.white)),
      ),
    ),
  ],
),

            
            const SizedBox(height: 20),
            const Text(
              "We’ve sent the verification code to the email you entered:",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(widget.email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isCodeEntered
                    ? () async {
                        if (codeController.text.trim() == generatedCode) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("The entered code is incorrect.")),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 130, 105),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Change Password", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
