import 'package:flutter/material.dart';

import 'HomePage.dart';

class Error404page extends StatelessWidget {
  const Error404page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/group_38.png',
                height: 200,
              ),
              const SizedBox(height: 30),
              const Text(
                "ERORR 404 \n page not found",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color:  Color.fromARGB(255, 139, 47, 47),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Oops! It looks like the page you're looking for doesn't exist or has been moved. Please try again or go back to the home page.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 79, 80, 85),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text("Back to home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
