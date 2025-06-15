import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Map<String, String>?> getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? place.administrativeArea ?? 'Unknown';
        String country = place.country ?? 'Unknown';

        return {
          'city': city,
          'country': country,
          'fullAddress':
              '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}',
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        };
      }
    } catch (e) {
      print('Error getting location: $e');
    }

    return null;
  }
}

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String locationText = "Getting location...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      isLoading = true;
    });

    final locationData = await LocationService.getCurrentLocation();

    setState(() {
      if (locationData != null) {
        locationText = "${locationData['city']}, ${locationData['country']}";
      } else {
        locationText = "Location not available";
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 4),
                    isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : Expanded(
                            child: Text(
                              locationText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _getUserLocation,
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     // Navigate to notifications
          //   },
          //   icon: Icon(
          //     Icons.notifications_outlined,
          //     color: Theme.of(context).primaryColor,
          //     size: 28,
          //   ),
          // ),
        ],
      ),
    );
  }
}
