import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> getUserCurrentLocation(BuildContext context) async {
  try {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!context.mounted) return null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are denied')),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition();
  } catch (e) {
    if (!context.mounted) return null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error getting current location: $e')),
    );
    return null;
  }
}
