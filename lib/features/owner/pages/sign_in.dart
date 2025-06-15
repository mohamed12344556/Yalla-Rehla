import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_rehla/core/utils/auth_guard.dart';

import 'ForgotPasswordPage.dart';
import 'welcom_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isButtonEnabled = false;
  bool isLoading = false;

  void _checkInput() {
    setState(() {
      RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      );
      bool isEmailValid = emailRegExp.hasMatch(_emailController.text.trim());
      isButtonEnabled =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          isEmailValid;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkInput);
    _passwordController.addListener(_checkInput);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final url = Uri.parse("http://20.74.208.111:5260/api/Owners/Login");

    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              ' Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJtb2hhbWVkYXphbHk3NzJAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiI4ZTA0OTA5NS01NzY4LTQyN2QtYWNmNy02NjU0ZGMxMmFlMGYiLCJqdGkiOiJhM2E4MTk3Ni0zYjYyLTQxZDEtYTljOC0yNDdkZGY2ZWZhMWUiLCJVc2VyVHlwZSI6Ik93bmVyIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiT3duZXIiLCJleHAiOjE3NDkzNzcxNTIsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NDY5NTAiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjU1NTU1In0.ud0bDN97hnzA9A-qkugyS7qtLxFGYa5eZ_9vhuOaMx0',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => welcom_page(email: email)),
        );
        await AuthGuard.saveUserRole(UserRole.business);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 221, 192),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80, top: 5),
                    child: SizedBox(
                      width: 321,
                      height: 251,
                      child: Image.asset(
                        'assets/images/group_31.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Column(
                      children: [
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Sign in to access your account",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Enter your email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      const Text(
                        "Remember me",
                        style: TextStyle(
                          color: Color.fromARGB(255, 101, 130, 105),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Color.fromARGB(255, 195, 58, 58)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled
                        ? const Color.fromARGB(255, 101, 130, 105)
                        : const Color.fromARGB(255, 207, 221, 192),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isButtonEnabled && !isLoading ? _login : null,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Next",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "New Member? Register now",
                    style: TextStyle(color: Color.fromARGB(255, 101, 130, 105)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
