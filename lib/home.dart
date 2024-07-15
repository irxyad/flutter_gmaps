import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_markers/common/create_marker.dart';
import 'package:maps_markers/common/get_location.dart';
import 'package:maps_markers/common/get_user_current_location.dart';
import 'package:maps_markers/main.dart';
import 'package:maps_markers/widgets/button.dart';
import 'core/const.dart';

part 'widgets/button_current_location.dart';
part 'widgets/button_clear_marker.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});
  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController _gMapController;
  final CameraPosition _kGooglePlex =
      const CameraPosition(target: LatLng(_latitude, _longtude), zoom: 14);
  static const double _longtude = 119.451332;
  static const double _latitude = -5.202745;
  final List<Marker> _markers = <Marker>[];
  String location = "Location";
  bool multipleMarker = false;
  double zoomLevel = 14;
  MapType _currentMapType = MapType.normal;

  // Load GMaps style
  String? _lightMapStyle;
  String? _darkMapStyle;

  Future _loadMapStyle() async {
    await rootBundle
        .loadString('assets/map_style/light_theme.json')
        .then((string) {
      _lightMapStyle = string;
    });

    await rootBundle
        .loadString('assets/map_style/dark_theme.json')
        .then((string) {
      _darkMapStyle = string;
    });
  }

// Trick to refresh gmaps
  void _reset() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const MapsScreen(),
      ),
    );
  }

// To get fixed zoom
  void _getZoom(CameraPosition position) {
    setState(() {
      zoomLevel = position.zoom;
    });
  }

  @override
  void initState() {
    _loadMapStyle();
    super.initState();
  }

  @override
  void dispose() {
    _gMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = MyApp.themeNotifier.value == ThemeMode.light;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _buttonCurrentLocation(lightTheme, location),
      ),
      body: Column(
        children: [
          _screenMap(lightTheme),
          _bottomMenu(lightTheme, context),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _markers.isNotEmpty
          ? _clearMarker(
              context,
              onPressed: () {
                _markers.clear();
                location = "Location";
              },
            )
          : const SizedBox(),
    );
  }

// Menus at bottom screen
  SingleChildScrollView _bottomMenu(bool lightTheme, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 20),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ButtonIcon(
              elevation: 0,
              label: lightTheme ? "Dark mode" : "Light mode",
              icon: lightTheme
                  ? const Icon(
                      Icons.dark_mode_rounded,
                    )
                  : Icon(
                      Icons.sunny,
                      color: Colors.amber.shade400,
                    ),
              onPressed: () {
                // showExitPopup(context, lightTheme, _reset);
                showDialog(
                    context: context,
                    barrierColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actionsOverflowAlignment: OverflowBarAlignment.center,
                        actionsPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 11),
                        actionsAlignment: MainAxisAlignment.end,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              MyApp.themeNotifier.value =
                                  lightTheme ? ThemeMode.dark : ThemeMode.light;

                              _reset();
                            },
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 0),
                            child: Text("Yes",
                                style: Theme.of(context).textTheme.bodyMedium!),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              shadowColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("No",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: white)),
                          )
                        ],
                        contentPadding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: white.withOpacity(.5))),
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text(
                          MyApp.themeNotifier.value == ThemeMode.dark
                              ? "Changing to Light Mode will erase existing markers.\nStill want to change it?"
                              : "Changing to Dark Mode will erase existing markers.\nStill want to change it?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: white),
                        ),
                      );
                    });
              }),
          const SizedBox(
            width: 11,
          ),
          ButtonIcon(
            elevation: 0,
            label: "My Location",
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () async {
              final myLocation = await getUserCurrentLocation(context);
              if (myLocation != null) {
                final latLng =
                    LatLng(myLocation.latitude, myLocation.longitude);
                await getLocation(latLng, _gMapController,
                    onSetAddress: (address) {
                  setState(() {
                    location = address;
                  });
                });

                _markers.add(
                  Marker(
                    markerId: const MarkerId("1"),
                    position: latLng,
                    infoWindow: InfoWindow(
                        title: "My Location",
                        snippet: "Latitude: ${myLocation.latitude}, "
                            " Longtude: ${myLocation.longitude}"),
                  ),
                );
                setState(() {
                  location = "My Location";
                });
              }
            },
          ),
          const SizedBox(
            width: 11,
          ),
          ButtonIcon(
            elevation: 0,
            label:
                multipleMarker == false ? "Single marker" : "Multiple marker",
            icon: MyApp.themeNotifier.value == ThemeMode.light
                ? SvgPicture.asset(
                    multipleMarker == false
                        ? "assets/icons/ic_single_marker.svg"
                        : "assets/icons/ic_multiple_marker.svg",
                    height: 18,
                  )
                : SvgPicture.asset(
                    multipleMarker == false
                        ? "assets/icons/ic_single_marker_dark.svg"
                        : "assets/icons/ic_multiple_marker_dark.svg",
                    height: 18,
                  ),
            onPressed: () {
              setState(() {
                multipleMarker = !multipleMarker;
              });
            },
          ),
          const SizedBox(
            width: 11,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PopupMenuButton<int>(
              offset: const Offset(0, 0),
              enableFeedback: true,
              color: lightTheme ? tealBlue : darkTealBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    onTap: () => setState(() {
                          _currentMapType = MapType.satellite;
                        }),
                    value: 0,
                    child: const JustText(
                        bgColor: Colors.transparent,
                        label: "Satelite",
                        icon: Icons.nature_people_rounded)),
                PopupMenuItem<int>(
                    onTap: () => setState(() {
                          _currentMapType = MapType.terrain;
                        }),
                    value: 1,
                    child: const JustText(
                        bgColor: Colors.transparent,
                        label: "Terrain",
                        icon: Icons.terrain_rounded)),
                PopupMenuItem<int>(
                    onTap: () => setState(() {
                          _currentMapType = MapType.hybrid;
                        }),
                    value: 2,
                    child: const JustText(
                        bgColor: Colors.transparent,
                        label: "Hybrid",
                        icon: Icons.maps_home_work_rounded)),
                PopupMenuItem<int>(
                    onTap: () => setState(() {
                          _currentMapType = MapType.normal;
                        }),
                    value: 2,
                    child: const JustText(
                        bgColor: Colors.transparent,
                        label: "Normal",
                        icon: Icons.map_rounded)),
              ],
              child: const ButtonIcon(
                elevation: 0,
                label: "Map type",
                icon: Icon(Icons.map_rounded),
              ),
            ),
          )
        ],
      ),
    );
  }

// Scren Map
  Expanded _screenMap(bool lightTheme) {
    return Expanded(
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: GoogleMap(
            onTap: (LatLng latLng) async {
              createMarker(
                latLng: latLng,
                gMapController: _gMapController,
                multipleMarker: multipleMarker,
                zoomLevel: zoomLevel,
                markers: _markers,
                context: context,
                location: location,
                onSetAddress: (address) {
                  setState(() {
                    location = address;
                  });
                },
              );
            },
            mapType: _currentMapType,
            indoorViewEnabled: true,
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            trafficEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(_markers),
            onCameraMove: _getZoom,
            onMapCreated: (GoogleMapController controller) {
              _gMapController = controller;
              _gMapController
                  // ignore: deprecated_member_use
                  .setMapStyle(lightTheme ? _lightMapStyle : _darkMapStyle);
            }),
      ),
    );
  }
}
