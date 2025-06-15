import 'package:flutter/material.dart';
import 'package:yalla_rehla/core/utils/extensions.dart';

import '../../../core/routes/routes.dart';
import '../../../core/utils/auth_guard.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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
              child: Image.asset('assets/images/group_34.png', height: 300),
            ),
            const SizedBox(height: 30),
            const Text(
              "Make connects with Travello",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "To your dream trip",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  // Mark that onboarding is completed
                  await AuthGuard.setNotFirstTime();

                  // Navigate to role selection using named route
                  context.pushReplacementNamed(Routes.roleSelection);
                },
                child: const Text("Get Started"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
