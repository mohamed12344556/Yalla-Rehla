// widgets/owner_card.dart
import 'package:flutter/material.dart';

class OwnerCard extends StatelessWidget {
  final String name;
  final VoidCallback onView;
  final VoidCallback onEdit;

  const OwnerCard({
    super.key,
    required this.name,
    required this.onView,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(name),
        subtitle: const Text("Lorem ipsum dolor, consectetur..."),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF558B2F)
),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
        onTap: onView,
      ),
    );
  }
}
