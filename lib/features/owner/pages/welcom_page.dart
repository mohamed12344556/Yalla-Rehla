import 'package:flutter/material.dart';

import 'HomePage.dart';

class welcom_page extends StatelessWidget {
  const welcom_page({super.key, required String email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 221, 192),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset('assets/images/group_35.png', height: 300),
            ),
            const SizedBox(height: 30),
            const Text(
              "Welcome to Home!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Currently The Next Part of Home Activity & Fragementation is under development. The upcoming Part 2 is coming Soon........",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text("Explore"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
