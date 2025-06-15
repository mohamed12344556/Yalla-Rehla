// widgets/trip_detail_info.dart
import 'dart:io';
import 'package:flutter/material.dart';

class TripDetailInfo extends StatelessWidget {
  final String destination;
  final String startDate;
  final String endDate;
  final File? imageFile;

  const TripDetailInfo({
    super.key,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageFile != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              imageFile!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
          ),
        const SizedBox(height: 20),
        Text("Destination: $destination", style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        Text("Start Date: $startDate", style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        Text("End Date: $endDate", style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
