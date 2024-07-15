import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

getLocation(
  LatLng latlng,
  GoogleMapController gMapController, {
  required Function(String address) onSetAddress,
}) async {
  CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latlng.latitude, latlng.longitude), zoom: 14);

  gMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  List<Placemark> placemark =
      await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
  Placemark place = placemark.first;
  String address = place.street!.contains("+") ? "Unknown" : place.street!;

  onSetAddress(address);
}
