import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:yalla_rehla/core/utils/extensions.dart';

import '../../../core/routes/routes.dart';
import '../../../core/utils/auth_guard.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 221, 192),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Are you a ... ?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 78, 86, 79),
                  ),
                ),
                const SizedBox(height: 24),
                CustomWideButton(
                  label: "Admin",
                  onTap: () async {
                    try {
                      // Save the selected role
                      await AuthGuard.saveUserRole(UserRole.admin);

                      // Navigate to login (using same login for all roles for now)
                      if (context.mounted) {
                        context.pushNamed(Routes.adminLogin);
                      }
                    } catch (e) {
                      // Handle error
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomWideButton(
                  label: "Business",

                  onTap: () async {
                    try {
                      // Save the selected role
                      await AuthGuard.saveUserRole(UserRole.business);

                      // Navigate to login (using same login for all roles for now)
                      if (context.mounted) {
                        context.pushNamed(Routes.businessLogin);
                      }
                    } catch (e) {
                      // Handle error
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomWideButton(
                  label: "Traveler",
                  onTap: () async {
                    try {
                      log('Role saved successfully 1');
                      // Save the selected role
                      await AuthGuard.saveUserRole(UserRole.traveler);
                      // Navigate to login
                      log('Role saved successfully 2');
                      if (context.mounted) {
                        log('Role saved successfully 3');
                        context.pushNamed(Routes.travelerLogin);
                      }
                    } catch (e) {
                      // Handle error
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomWideButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CustomWideButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 207, 221, 192),
              foregroundColor: const Color.fromARGB(255, 52, 58, 53),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: Color.fromARGB(255, 52, 58, 53),
                  width: 1,
                ),
              ),
              elevation: 0,
              shadowColor: Colors.black.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                Colors.black.withOpacity(0.05),
              ),
            ),
        child: Text(label),
      ),
    );
  }
}
