// Screens/TripDetailsAdminPage.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../widgets/trip_detail_info.dart';

class TripDetailsAdminPage extends StatelessWidget {
  final Map<String, dynamic> trip;

  const TripDetailsAdminPage({super.key, required this.trip});
  

  @override
  Widget build(BuildContext context) {
    final String destination = trip['destination'] ?? 'Unknown destination';
    final String startDate = trip['startDate'] ?? 'No start date';
    final String endDate = trip['endDate'] ?? 'No end date';
    final File? imageFile = trip['image'] != null ? File(trip['image'].path) : null;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 221, 192),
      appBar: AppBar(
        title: const Text("Trip Details", style: TextStyle(color:   Color.fromARGB(255, 207, 221, 192))),
        backgroundColor: const Color.fromARGB(255, 101, 130, 105),
      
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color:  Color.fromARGB(255, 207, 221, 192),),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color:   Color.fromARGB(255, 207, 221, 192)),
            onPressed: () {
              Share.share(
                "Trip to $destination\nFrom $startDate to $endDate",
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Confirm Delete"),
                  content: const Text("Are you sure you want to delete this trip?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx); 
                        Navigator.pop(context, 'delete'); 
                      },
                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TripDetailInfo(
              destination: destination,
              startDate: startDate,
              endDate: endDate,
              imageFile: imageFile,
            ),
          ),
        ],
      ),
    );
  }
}
