import 'package:flutter/material.dart';
import 'package:yalla_rehla/core/utils/extensions.dart';

import '../../../core/routes/routes.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/auth_guard.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  bool _isLoading = false;

  Future<void> _selectRole(UserRole role, String route) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // تطبيق الثيم مع التأخير
      await ThemeRoleManager.setTemporaryRole(role);

      // تأخير إضافي لضمان تطبيق الثيم
      await Future.delayed(const Duration(milliseconds: 200));

      if (mounted) {
        context.pushNamed(route);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

                if (_isLoading)
                  const CircularProgressIndicator()
                else ...[
                  CustomWideButton(
                    label: "Admin",
                    onTap: () => _selectRole(UserRole.admin, Routes.adminLogin),
                  ),
                  const SizedBox(height: 16),
                  CustomWideButton(
                    label: "Business Owner",
                    onTap: () =>
                        _selectRole(UserRole.business, Routes.businessLogin),
                  ),
                  const SizedBox(height: 16),
                  CustomWideButton(
                    label: "Traveler",
                    onTap: () =>
                        _selectRole(UserRole.traveler, Routes.travelerLogin),
                  ),
                ],
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
