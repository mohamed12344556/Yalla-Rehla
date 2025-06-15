import 'package:flutter/material.dart';
import '../widgets/owner_card.dart';
import 'owner_details_page.dart';
import 'add_edit_owner_page.dart';

class OwnersListPage extends StatelessWidget {
  const OwnersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owners List"),
        backgroundColor:  const Color.fromARGB(255, 207, 221, 192),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (context, index) {
          return OwnerCard(
            name: "User ${index + 1}",
            onView: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OwnerDetailsPage()),
              );
            },
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditOwnerPage()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditOwnerPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
