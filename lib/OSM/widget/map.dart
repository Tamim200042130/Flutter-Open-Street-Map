import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(23.7260, 90.3976),
            zoom: 13.0,
            interactionOptions: InteractionOptions(
              flags: ~InteractiveFlag.doubleTapZoom,
            ),
          ),
          children: [
            openStreetMapTileLayer,
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(23.7260, 90.3976),
                  width: 40,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      print('Marker tapped');
                    },
                    child: Icon(Icons.location_on,
                        size: 60, color: Colors.redAccent),
                  ),
                ),
                if (_currentLocation != null)
                  Marker(
                    point: _currentLocation!,
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    child: Icon(Icons.my_location,
                        size: 30, color: Colors.blueAccent),
                  ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            onPressed: _goToCurrentLocation,
            child: Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }

  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentLocation!, 13.0);
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      );
}
