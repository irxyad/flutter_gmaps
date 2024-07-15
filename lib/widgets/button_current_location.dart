part of '../home.dart';

// Button to get user current location
Padding _buttonCurrentLocation(bool lightTheme, String location) {
  return Padding(
    padding: const EdgeInsets.only(top: 11.0),
    child: ButtonIcon(
        elevation: 2,
        label: location,
        icon: Icon(
          Icons.location_on_rounded,
          color: lightTheme ? Colors.red.shade800 : Colors.red,
          size: 17,
        ),
        onPressed: () {}),
  );
}
