import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapPolylinesPage extends StatefulWidget {
  const MapPolylinesPage({Key? key}) : super(key: key);

  @override
  _MapPolylinesPageState createState() => _MapPolylinesPageState();
}

class _MapPolylinesPageState extends State<MapPolylinesPage>
    with SingleTickerProviderStateMixin {
  late MapZoomPanBehavior _zoomPanBehavior;
  MapTileLayerController? _mapController;
  late bool _isDesktop;
  late MapLatLng _currentLocation;
  AnimationController? _animationController;

  @override
  void initState() {
    _mapController = MapTileLayerController();
    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 3,
      zoomLevel: 10,
      toolbarSettings: MapToolbarSettings(
          direction: Axis.vertical, position: MapToolbarPosition.bottomRight),
      maxZoomLevel: 15,
      enableDoubleTapZooming: true,
    );

    _getCurrentLocation();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = MapLatLng(position.latitude, position.longitude);
      _zoomPanBehavior.focalLatLng = _currentLocation;
      _zoomPanBehavior.zoomLevel = 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            initialMarkersCount: 1,
            controller: _mapController,
            markerBuilder: (BuildContext context, int index) {
              return MapMarker(
                latitude: _currentLocation.latitude,
                longitude: _currentLocation.longitude,
                child: _buildLocationIndicator(),
              );
            },
            sublayers: [
              MapPolylineLayer(
                polylines: _buildPolylines(),
              ),
            ],
            zoomPanBehavior: _zoomPanBehavior,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _updateLocation();
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  Set<MapPolyline> _buildPolylines() {
    final Set<MapPolyline> polylines = {};
    if (_currentLocation != null) {
      final List<MapLatLng> points = [];
      // Add your polyline points here
      points.add(_currentLocation);
      points.add(MapLatLng(_currentLocation.latitude + 0.01, _currentLocation.longitude + 0.01)); // Example points
      polylines.add(MapPolyline(
        points: points,
        color: Colors.red,
        width: 6.0,
      ));
    }
    return polylines;
  }

  Future<void> _updateLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final newLocation = MapLatLng(position.latitude, position.longitude);
    setState(() {
      _currentLocation = newLocation;
      _zoomPanBehavior.focalLatLng = _currentLocation;
    });

    _animateCamera(_currentLocation);
  }

  void _animateCamera(MapLatLng newLocation) {
    _animationController!.reset();
    _animationController!.forward();
  }

  Widget _buildLocationIndicator() {
    return Icon(
      Icons.location_on,
      color: Colors.blue,
      size: 36.0,
    );
  }
}
