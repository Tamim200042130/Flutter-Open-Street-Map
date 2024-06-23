import 'dart:convert';
import 'dart:math' as Math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../../../../model/sample_view.dart';

class MapPolylinesPage extends SampleView {
  const MapPolylinesPage(Key key) : super(key: key);

  @override
  _PolylinesSampleState createState() => _PolylinesSampleState();
}

class _PolylinesSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late MapZoomPanBehavior _zoomPanBehavior;
  MapTileLayerController? _mapController;
  AnimationController? _animationController;
  late Animation _animation;
  late bool _isDesktop;
  List<_RouteDetails> _routes = [];
  Set<MapPolyline> _polylines = {};
  late ThemeData _themeData;
  MapLatLng? _currentLocation;

  @override
  void initState() {
    _routes = <_RouteDetails>[
      _RouteDetails(MapLatLng(51.4700, -0.4543), null, 'London Heathrow',
          'assets/london_to_british.json'),
      _RouteDetails(MapLatLng(51.5194, -0.1270), null, 'The British Museum',
          'assets/london_to_british.json'),
      _RouteDetails(MapLatLng(51.4839, -0.6044), null, 'Windsor Castle',
          'assets/london_to_windsor_castle.json'),
      _RouteDetails(MapLatLng(51.4560, -0.3415), null, 'Twickenham Stadium',
          'assets/london_to_twickenham_stadium.json'),
      _RouteDetails(
          MapLatLng(51.3472, -0.3192),
          null,
          'Chessington World of Adventures',
          'assets/london_to_chessington.json'),
      _RouteDetails(MapLatLng(51.4036, -0.3378), null, 'Hampton Court Palace',
          'assets/london_to_hampton_court_palace.json'),
    ];
    _mapController = MapTileLayerController();
    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 3,
      zoomLevel: 10,
      focalLatLng: MapLatLng(51.4700, -0.2843),
      toolbarSettings: MapToolbarSettings(
          direction: Axis.vertical, position: MapToolbarPosition.bottomRight),
      maxZoomLevel: 15,
      enableDoubleTapZooming: true,
    );
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
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

  double _calculateBearing(MapLatLng start, MapLatLng end) {
    double startLat = start.latitude * (3.141592653589793 / 180);
    double startLng = start.longitude * (3.141592653589793 / 180);
    double endLat = end.latitude * (3.141592653589793 / 180);
    double endLng = end.longitude * (3.141592653589793 / 180);

    double dLng = endLng - startLng;
    double x = Math.sin(dLng) * Math.cos(endLat);
    double y = Math.cos(startLat) * Math.sin(endLat) -
        Math.sin(startLat) * Math.cos(endLat) * Math.cos(dLng);
    double bearing = Math.atan2(x, y);
    bearing = bearing * (180 / 3.141592653589793);
    bearing = (bearing + 360) % 360;
    return bearing;
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        _themeData.platform == TargetPlatform.macOS ||
        _themeData.platform == TargetPlatform.windows ||
        _themeData.platform == TargetPlatform.linux;
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

                // Calculate the bearing if it's not the last marker
                double rotation = 0;
                if (index < _routes.length - 1) {
                  rotation = _calculateBearing(
                      _routes[index].latLan, _routes[index + 1].latLan);
                }

                return MapMarker(
                  key: UniqueKey(),
                  latitude: _routes[index].latLan.latitude,
                  longitude: _routes[index].latLan.longitude,
                  child: Transform.rotate(
                    angle: rotation * (3.141592653589793 / 180),
                    // Convert bearing to radians
                    child: IconButton(
                      icon: _routes[index].icon ??
                          Icon(
                            Icons.bus_alert_rounded,
                            color: index == 0
                                ? Colors.green[600]
                                : Colors.red[600],
                            size: 30,
                          ),
                      onPressed: () {
                        _onMarkerTapped(index);
                      },
                    ),
                  ),
                );
              },
              tooltipSettings: MapTooltipSettings(
                color: Color.fromRGBO(45, 45, 45, 1),
              ),
              markerTooltipBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_routes[index].city,
                      style: _themeData.textTheme.bodySmall!
                          .copyWith(color: Color.fromRGBO(255, 255, 255, 1))),
                );
              },
              sublayers: [
                MapPolylineLayer(
                  polylines: _polylines,
                  tooltipBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _routes[0].city + ' - ' + _routes[1].city,
                        style: _themeData.textTheme.bodySmall!
                            .copyWith(color: Color.fromRGBO(255, 255, 255, 1)),
                      ),
                    );
                  },
                ),
              ],
              zoomPanBehavior: _zoomPanBehavior,
            ),
          ],
        ),
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
  }
}

class _RouteDetails {
  _RouteDetails(this.latLan, this.icon, this.city, this.jsonFile);

  MapLatLng latLan;
  Widget? icon;
  String city;
  String jsonFile;
}
