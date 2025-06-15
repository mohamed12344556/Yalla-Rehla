import 'package:flutter/material.dart';

import 'AllChatspage.dart';
import 'NotificationsAdminPage.dart';
import 'Profile_Admin_Page.dart';
import 'TripDetailsAdminPage.dart';


class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> trips = [
    {
      "id": 1,
      "destination": "Cairo",
      "date": "2025-05-01",
      "time": "10:00 AM",
      "user": "Ahmed",
      "status": "accepted",
      "details": "A day trip to visit the pyramids and the Egyptian Museum."
    },
    {
      "id": 2,
      "destination": "Alexandria",
      "date": "2025-05-05",
      "time": "09:00 AM",
      "user": "Sarah",
      "status": "accepted",
      "details": "A seaside escape with seafood lunch and Corniche walk."
    },
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const Profile_Admin_Page(email: '', fullName: ''),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationsPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final acceptedTrips = trips.where((trip) => trip['status'] == 'accepted').toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 221, 192),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 207, 221, 192),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox.shrink(),
            ListTile(
              leading: const Icon(Icons.person,color: Color.fromARGB(255, 101, 130, 105),),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Profile_Admin_Page(email: '', fullName: ''),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Welcome!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 130, 105),
        elevation: 6,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: acceptedTrips.isEmpty
          ? const Center(child: Text("No accepted trips yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: acceptedTrips.length,
              itemBuilder: (context, index) {
                final trip = acceptedTrips[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(
                      "${trip['destination']} - ${trip['date']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Requested by: ${trip['user']}"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripDetailsAdminPage(trip: trip),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor:const Color.fromARGB(255, 101, 130, 105),
        unselectedItemColor: Colors.grey[300],
        backgroundColor:const Color.fromARGB(255, 101, 130, 105),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Color.fromARGB(255, 101, 130, 105)),
            label: "Home",
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Color.fromARGB(255, 101, 130, 105)),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications,color:  Color.fromARGB(255, 101, 130, 105)),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat,color: Color.fromARGB(255, 101, 130, 105)),
            label: "Chat",
          ),
        ],
      ),
    );
  }
}
