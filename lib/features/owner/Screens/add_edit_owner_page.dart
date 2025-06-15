// Screens/add_edit_owner_page.dart
import 'package:flutter/material.dart';

class AddEditOwnerPage extends StatelessWidget {
  const AddEditOwnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController locationController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add/Edit Owner"),
        backgroundColor:  const Color.fromARGB(255, 207, 221, 192),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "User Name",
                hintText: "Add username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "User Email",
                hintText: "Add user email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "User Location",
                hintText: "Add user location",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 207, 221, 192),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Add"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
