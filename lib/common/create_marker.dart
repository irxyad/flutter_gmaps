// to create a new marker(single or multiple marker)
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_markers/common/get_location.dart';

Future createMarker({
  required GoogleMapController gMapController,
  required LatLng latLng,
  required bool multipleMarker,
  required double zoomLevel,
  required List<Marker> markers,
  required BuildContext context,
  required String location,
  required Function(String address) onSetAddress,
}) async {
  // Get the location when the maps screen is pressed
  await getLocation(latLng, gMapController,
      onSetAddress: (address) => onSetAddress);

  // Then add marker
  if (multipleMarker) {
    markers.add(
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
            Random().nextDouble() * Random().nextInt(360)),
        markerId: MarkerId(latLng.latitude.toString()),
        position: latLng,
        infoWindow: InfoWindow(
            title: location,
            snippet: "Latitude: ${latLng.latitude}, "
                "Longtude: ${latLng.longitude}"),
      ),
    );
  } else {
    markers.add(
      Marker(
        markerId: const MarkerId("1"),
        position: latLng,
        infoWindow: InfoWindow(
            title: location,
            snippet: "Latitude: ${latLng.latitude}, "
                " Longtude: ${latLng.longitude}"),
      ),
    );
  }
}
