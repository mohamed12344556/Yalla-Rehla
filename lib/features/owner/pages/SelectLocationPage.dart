import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor:const Color.fromARGB(255, 101, 130, 105),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.033333, 31.233334), 
              zoom: 10,
            ),
            onTap: (LatLng position) {
              setState(() {
                selectedLocation = position;
              });
            },
            markers: selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId("selected-location"),
                      position: selectedLocation!,
                    )
                  }
                : {},
          ),
          if (selectedLocation != null)
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 130, 105),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    "${selectedLocation!.latitude}, ${selectedLocation!.longitude}",
                  );
                },
                child: const Text("Confirm Location"),
              ),
            ),
        ],
      ),
    );
  }
}
