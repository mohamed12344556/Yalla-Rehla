// Screens/AllChatspage.dart
import 'package:flutter/material.dart';
import 'chat_page.dart';

class ChatsPage extends StatelessWidget {
  final List<Map<String, dynamic>> dummyChats = [
    {
      'name': 'Owner 1',
      'lastMessage': 'Hello, how are you?',
      'time': '10:30 AM',
    },
    {
      'name': 'Owner 2',
      'lastMessage': 'The trip is confirmed!',
      'time': '09:00 AM',
    },
    {
      'name': 'Owner 3',
      'lastMessage': 'Thanks for your help.',
      'time': 'Yesterday',
    },
  ];

  ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: dummyChats.length,
        itemBuilder: (context, index) {
          final chat = dummyChats[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor:   Color.fromARGB(255, 207, 221, 192),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(chat['name']),
            subtitle: Text(chat['lastMessage']),
            trailing: Text(chat['time']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    ownerName: chat['name'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
