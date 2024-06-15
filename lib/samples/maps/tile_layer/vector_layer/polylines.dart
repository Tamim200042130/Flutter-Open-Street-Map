import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../../../model/sample_view.dart';

class MapPolylinesPage extends SampleView {

  @override
  _MapPolylinesPageState createState() => _MapPolylinesPageState();
}

class _MapPolylinesPageState extends State<MapPolylinesPage>
    with SingleTickerProviderStateMixin {
  late MapZoomPanBehavior _zoomPanBehavior;
  MapTileLayerController? _mapController;
  late bool _isDesktop;
  List<_RouteDetails> _routes = [];
  Set<MapPolyline> _polylines = {};
  late ThemeData _themeData;
  MapLatLng? _currentLocation;

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
      print('Current Location: $_currentLocation');
      _routes[0] = _RouteDetails(
        _currentLocation!,
        Icon(
          Icons.my_location,
          color: Colors.blue,
          size: 30,
        ),
        'Current Location',
        '',
      );
      _zoomPanBehavior.focalLatLng = _currentLocation!;
      _zoomPanBehavior.zoomLevel = 15;
      print('Routes updated: ${_routes[0].latLan}');
    });

    _mapController?.updateMarkers([0]);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    _mapController?.dispose();
    _mapController = null;
    _routes.clear();
    super.dispose();
  }

  Future<List<MapLatLng>> getJsonData(String jsonFile) async {
    final List<MapLatLng> polyline = <MapLatLng>[];
    final String data = await rootBundle.loadString(jsonFile);
    final dynamic jsonData = json.decode(data);
    final List<dynamic> polylinePoints =
        jsonData['features'][0]['geometry']['coordinates'];
    for (int i = 0; i < polylinePoints.length; i++) {
      polyline.add(MapLatLng(polylinePoints[i][1], polylinePoints[i][0]));
    }
    _animationController?.forward(from: 0);

    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfMapsTheme(
        data: SfMapsThemeData(
          shapeHoverColor: Colors.transparent,
        ),
        child: SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              initialMarkersCount: _routes.length,
              controller: _mapController,
              markerBuilder: (BuildContext context, int index) {
                print(
                    'Building marker for index: $index, location: ${_routes[index].latLan}');
                return MapMarker(
                  key: UniqueKey(),
                  latitude: _routes[index].latLan.latitude,
                  longitude: _routes[index].latLan.longitude,
                  child: IconButton(
                    icon: _routes[index].icon ??
                        Icon(
                          Icons.location_on,
                          color:
                              index == 0 ? Colors.green[600] : Colors.red[600],
                          size: 30,
                        ),
                    onPressed: () {
                      _onMarkerTapped(index);
                    },
                  ),
                );
              },
              tooltipSettings: MapTooltipSettings(
                color: Color.fromRGBO(45, 45, 45, 1),
              ),
            ],
            zoomPanBehavior: _zoomPanBehavior,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _getCurrentLocation();
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  void _onMarkerTapped(int index) async {
    if (index == 0) {
      setState(() {
        _polylines.clear();
      });
    } else {
      final List<MapLatLng> polylinePoints =
          await getJsonData(_routes[index].jsonFile);
      setState(() {
        _polylines = {
          MapPolyline(
            points: polylinePoints,
            color: Color.fromRGBO(0, 102, 255, 1.0),
            width: 6.0,
          ),
        };
      });
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
