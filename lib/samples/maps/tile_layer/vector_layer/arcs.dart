/// Flutter package imports
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/rendering.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map arc sample
class MapArcsPage extends SampleView {
  /// Creates the map arc sample
  const MapArcsPage(Key key) : super(key: key);

  @override
  _ArcsSampleState createState() => _ArcsSampleState();
}

class _ArcsSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late List<_AirRouteDetails> _airports;
  late List<_MarkerData> _markerData;
  late MapZoomPanBehavior _zoomPanBehavior;
  late MapTileLayerController _mapController;
  late AnimationController _animationController;
  late Animation _animation;
  int _currentSelectedCityIndex = 0;
  bool _isDesktop = false;
  bool _enableDashArray = false;
  late bool _canUpdateZoomLevel;
  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  late String _currentSublayer;
  late Color _layerColor;
  late List<double> _dashArray;

  @override
  void initState() {
    _mapController = MapTileLayerController();

    _zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: MapLatLng(40.7128, -74.0060),
      toolbarSettings: MapToolbarSettings(
        direction: Axis.vertical,
        position: MapToolbarPosition.bottomRight,
      ),
      enableDoubleTapZooming: true,
      maxZoomLevel: 12,
    );

    _setNavigationLineData(_currentSelectedCityIndex);

    _dropDownMenuItems = _getDropDownMenuItems();
    _currentSublayer = _dropDownMenuItems[0].value!;
    _canUpdateZoomLevel = true;
    _dashArray = [0, 0];

    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    _animationController.forward(from: 0);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController.dispose();
    _markerData.clear();
    _airports.clear();
    super.dispose();
  }

  void _setNavigationLineData(int index) {
    switch (index) {
      case 0:
        _layerColor = Color.fromRGBO(167, 61, 233, 1.0);
        _markerData = <_MarkerData>[
          _MarkerData('New York', MapLatLng(40.7128, -74.0060)),
          _MarkerData('Denver', MapLatLng(39.7392, -104.9903)),
          _MarkerData('Bogata', MapLatLng(4.7110, -74.0721)),
          _MarkerData('Calgary', MapLatLng(51.0447, -114.0719)),
          _MarkerData('Tashkent', MapLatLng(41.2995, 69.2401)),
          _MarkerData('Dakar', MapLatLng(14.7167, -17.4677)),
          _MarkerData('Casablanca', MapLatLng(33.3700, -7.5857)),
          _MarkerData('Houston', MapLatLng(29.7604, -95.3698)),
          _MarkerData('Edmonton', MapLatLng(53.5461, -113.4938)),
          _MarkerData('Panama City', MapLatLng(8.9824, -79.5199)),
        ];

        _airports = <_AirRouteDetails>[
          _AirRouteDetails(MapLatLng(40.7128, -74.0060),
              MapLatLng(4.7110, -74.0721), 'New York - Bogata'),
          _AirRouteDetails(MapLatLng(40.7128, -74.0060),
              MapLatLng(51.0447, -114.0719), 'New York - Calgary'),
          _AirRouteDetails(MapLatLng(40.7128, -74.0060),
              MapLatLng(41.2995, 69.2401), 'New York - Tashkent'),
          _AirRouteDetails(MapLatLng(40.7128, -74.0060),
              MapLatLng(14.7167, -17.4677), 'New York - Dakar'),
          _AirRouteDetails(MapLatLng(40.7128, -74.0060),
              MapLatLng(33.3700, -7.5857), 'New York - Casablanca'),
          _AirRouteDetails(MapLatLng(40.7128, -74.0060),
              MapLatLng(29.7604, -95.3698), 'New York - Houston'),
          _AirRouteDetails(MapLatLng(40.7128, -74.0060),
              MapLatLng(53.5461, -113.4938), 'New York - Edmonton'),
          _AirRouteDetails(MapLatLng(40.7128, -74.0060),
              MapLatLng(8.9824, -79.5199), 'New York - Panama City'),
          _AirRouteDetails(MapLatLng(40.7128, -74.0060),
              MapLatLng(39.7392, -104.9903), 'New york - Denver'),
        ];
        _updateMarkers();
        break;

      case 1:
        _layerColor = Color.fromRGBO(65, 72, 22, 1.0);
        _markerData = <_MarkerData>[
          _MarkerData('Denver', MapLatLng(39.7392, -104.9903)),
          _MarkerData('New York', MapLatLng(40.7128, -74.0060)),
          _MarkerData('Calgary', MapLatLng(51.0447, -114.0719)),
          _MarkerData('Edmonton', MapLatLng(53.5461, -113.4938)),
          _MarkerData('Paris', MapLatLng(48.8566, 2.3522)),
          _MarkerData('Panama City', MapLatLng(8.9824, -79.5199)),
        ];

        _airports = <_AirRouteDetails>[
          _AirRouteDetails(MapLatLng(39.7392, -104.9903),
              MapLatLng(53.5461, -113.4938), 'Denver - Edmonton'),
          _AirRouteDetails(MapLatLng(39.7392, -104.9903),
              MapLatLng(51.0447, -114.0719), 'Denver - Calgary'),
          _AirRouteDetails(MapLatLng(39.7392, -104.9903),
              MapLatLng(40.7128, -74.0060), 'Denver - New York'),
          _AirRouteDetails(MapLatLng(39.7392, -104.9903),
              MapLatLng(48.8566, 2.3522), 'Denver - Paris'),
          _AirRouteDetails(MapLatLng(39.7392, -104.9903),
              MapLatLng(8.9824, -79.5199), 'Denver - Panama City'),
        ];
        _updateMarkers();
        break;

      case 2:
        _layerColor = Color.fromRGBO(12, 152, 34, 1.0);
        _markerData = <_MarkerData>[
          _MarkerData('London', MapLatLng(51.4700, 0.4543)),
          _MarkerData('Bogata', MapLatLng(4.7110, -74.0721)),
          _MarkerData('Calgary', MapLatLng(51.0447, -114.0719)),
          _MarkerData('Moscow', MapLatLng(55.7558, 37.6173)),
          _MarkerData('Riyath', MapLatLng(24.7136, 46.6753)),
          _MarkerData('Seoul', MapLatLng(37.5665, 126.9780)),
        ];

        _airports = <_AirRouteDetails>[
          _AirRouteDetails(MapLatLng(51.4700, 0.4543),
              MapLatLng(51.0447, -114.0719), 'London - Calgary'),
          _AirRouteDetails(MapLatLng(51.4700, 0.4543),
              MapLatLng(4.7110, -74.0721), 'London - Bogata'),
          _AirRouteDetails(MapLatLng(51.4700, 0.4543),
              MapLatLng(55.7558, 37.6173), 'London - Moscow'),
          _AirRouteDetails(MapLatLng(51.4700, 0.4543),
              MapLatLng(24.7136, 46.6753), 'London - Riyath'),
          _AirRouteDetails(MapLatLng(51.4700, 0.4543),
              MapLatLng(37.5665, 126.9780), 'London - Seoul'),
        ];
        _updateMarkers();
        break;

      case 3:
        _layerColor = Color.fromRGBO(226, 75, 65, 1.0);
        _markerData = <_MarkerData>[
          _MarkerData('Dublin', MapLatLng(53.3498, -6.2603)),
          _MarkerData('New York', MapLatLng(40.7128, -74.0060)),
          _MarkerData('Hong Kong', MapLatLng(22.3193, 114.1694)),
          _MarkerData('Calgary', MapLatLng(51.0447, -114.0719)),
          _MarkerData('Addis Abada', MapLatLng(8.9806, 38.7578)),
          _MarkerData('Helsinki', MapLatLng(60.1699, 24.9384)),
        ];

        _airports = <_AirRouteDetails>[
          _AirRouteDetails(MapLatLng(53.3498, -6.2603),
              MapLatLng(22.3193, 114.1694), 'Dublin - Hong Kong'),
          _AirRouteDetails(MapLatLng(53.3498, -6.2603),
              MapLatLng(8.9806, 38.7578), 'Dublin - Addis Abada'),
          _AirRouteDetails(MapLatLng(53.3498, -6.2603),
              MapLatLng(60.1699, 24.9384), 'Dublin - Helsinki'),
          _AirRouteDetails(MapLatLng(53.3498, -6.2603),
              MapLatLng(40.7128, -74.0060), 'Dublin - New York'),
          _AirRouteDetails(MapLatLng(53.3498, -6.2603),
              MapLatLng(51.0447, -114.0719), 'Dublin - Calgary'),
        ];
        _updateMarkers();
        break;

      case 4:
        _layerColor = Color.fromRGBO(108, 27, 212, 1.0);
        _markerData = <_MarkerData>[
          _MarkerData('Beijing', MapLatLng(39.9042, 116.4074)),
          _MarkerData('Seoul', MapLatLng(37.5665, 126.9780)),
          _MarkerData('Islamabad', MapLatLng(33.6844, 73.0479)),
          _MarkerData('Addis Abada', MapLatLng(8.9806, 38.7578)),
          _MarkerData('Tokyo', MapLatLng(35.6762, 139.6503)),
          _MarkerData('Helsinki', MapLatLng(60.1699, 24.9384)),
          _MarkerData('Korla', MapLatLng(41.7259, 86.1746)),
        ];

        _airports = <_AirRouteDetails>[
          _AirRouteDetails(MapLatLng(39.9042, 116.4074),
              MapLatLng(33.6844, 73.0479), 'Beijing - Islamabad'),
          _AirRouteDetails(MapLatLng(39.9042, 116.4074),
              MapLatLng(8.9806, 38.7578), 'Beijing - Addis Abada'),
          _AirRouteDetails(MapLatLng(39.9042, 116.4074),
              MapLatLng(35.6762, 139.6503), 'Beijing - Tokyo'),
          _AirRouteDetails(MapLatLng(39.9042, 116.4074),
              MapLatLng(60.1699, 24.9384), 'Beijing - Helsinki'),
          _AirRouteDetails(MapLatLng(39.9042, 116.4074),
              MapLatLng(41.7259, 86.1746), 'Beijing - Korla'),
          _AirRouteDetails(MapLatLng(39.9042, 116.4074),
              MapLatLng(37.5665, 126.9780), 'Beijing - Seoul'),
        ];
        _updateMarkers();
        break;
      case 5:
        _layerColor = Color.fromRGBO(236, 40, 134, 1.0);
        _markerData = <_MarkerData>[
          _MarkerData('Delhi', MapLatLng(28.7041, 77.1025)),
          _MarkerData('London', MapLatLng(51.4700, 0.4543)),
          _MarkerData('Beijing', MapLatLng(39.9042, 116.4074)),
          _MarkerData('Chennai', MapLatLng(13.0827, 80.2707)),
          _MarkerData('New York', MapLatLng(40.7128, -74.0060)),
          _MarkerData('Sydney', MapLatLng(-33.8688, 151.2093)),
          _MarkerData('Mumbai', MapLatLng(19.0931, 72.8568)),
        ];

        _airports = <_AirRouteDetails>[
          _AirRouteDetails(MapLatLng(28.7041, 77.1025),
              MapLatLng(51.4700, 0.4543), 'Delhi - London'),
          _AirRouteDetails(MapLatLng(28.7041, 77.1025),
              MapLatLng(40.7128, -74.0060), 'Delhi - New York'),
          _AirRouteDetails(MapLatLng(28.7041, 77.1025),
              MapLatLng(-33.8688, 151.2093), 'Delhi - Sydney'),
          _AirRouteDetails(MapLatLng(28.7041, 77.1025),
              MapLatLng(39.9042, 116.4074), 'Delhi - Beijing'),
          _AirRouteDetails(MapLatLng(28.7041, 77.1025),
              MapLatLng(13.0827, 80.2707), 'Delhi - Chennai'),
          _AirRouteDetails(MapLatLng(28.7041, 77.1025),
              MapLatLng(19.0931, 72.8568), 'Delhi - Mumbai'),
        ];
        _updateMarkers();
        break;
      case 6:
        _layerColor = Color.fromRGBO(2, 130, 122, 1.0);
        _markerData = <_MarkerData>[
          _MarkerData('Chennai', MapLatLng(13.0827, 80.2707)),
          _MarkerData('London', MapLatLng(51.4700, 0.4543)),
          _MarkerData('Delhi', MapLatLng(28.7041, 77.1025)),
          _MarkerData('Riyath', MapLatLng(24.7136, 46.6753)),
          _MarkerData('Tokyo', MapLatLng(35.6762, 139.6503)),
          _MarkerData('Singapore', MapLatLng(1.3521, 103.8198)),
          _MarkerData('Addis Abada', MapLatLng(8.9806, 38.7578)),
        ];

        _airports = <_AirRouteDetails>[
          _AirRouteDetails(MapLatLng(13.0827, 80.2707),
              MapLatLng(51.507351, -0.127758), 'Chennai - London'),
          _AirRouteDetails(MapLatLng(13.0827, 80.2707),
              MapLatLng(35.6762, 139.6503), 'Chennai - Tokyo'),
          _AirRouteDetails(MapLatLng(13.0827, 80.2707),
              MapLatLng(8.9806, 38.7578), 'Chennai - Addis Abada'),
          _AirRouteDetails(MapLatLng(13.0827, 80.2707),
              MapLatLng(24.7136, 46.6753), 'Chennai - Riyath'),
          _AirRouteDetails(MapLatLng(13.0827, 80.2707),
              MapLatLng(1.3521, 103.8198), 'Chennai - Singapore'),
          _AirRouteDetails(MapLatLng(13.0827, 80.2707),
              MapLatLng(28.7041, 77.1025), 'Chennai - Delhi'),
        ];
        _updateMarkers();
        break;
    }
  }

  void _updateMarkers() {
    _mapController.clearMarkers();
    for (int i = 0; i < _markerData.length; i++) {
      _mapController.insertMarker(i);
    }
  }

  List<DropdownMenuItem<String>> _getDropDownMenuItems() {
    final List<DropdownMenuItem<String>> sublayerItems = [
      DropdownMenuItem(value: 'Arcs', child: Text('Arcs')),
      DropdownMenuItem(value: 'Lines', child: Text('Lines'))
    ];
    return sublayerItems;
  }

  MapSublayer _getCurrentSublayer(_currentLegend) {
    if (_currentLegend == 'Arcs') {
      return MapArcLayer(
        arcs: List<MapArc>.generate(
          _airports.length,
              (int index) {
            return MapArc(
              from: _airports[index].from,
              to: _airports[index].to,
              dashArray: _dashArray,
              heightFactor: index == 5 &&
                  _airports[index].to == MapLatLng(13.0827, 80.2707)
                  ? 0.5
                  : 0.2,
              color: _layerColor,
              width: 2.0,
            );
          },
        ).toSet(),
        // animation: _animation,
        tooltipBuilder: _tooltipBuilder,
      );
    } else {
      return MapLineLayer(
        lines: List<MapLine>.generate(
          _airports.length,
              (int index) {
            return MapLine(
              from: _airports[index].from,
              to: _airports[index].to,
              dashArray: _dashArray,
              color: _layerColor,
              width: 2.0,
            );
          },
        ).toSet(),
        // animation: _animation,
        tooltipBuilder: _tooltipBuilder,
      );
    }
  }

  Widget _tooltipBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: Container(
        height: _isDesktop ? 45 : 40,
        child: Column(
          children: [
            Text('Route',
                style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 1))),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(_airports[index].destination,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Color.fromRGBO(255, 255, 255, 1))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    if (_canUpdateZoomLevel) {
      _zoomPanBehavior.zoomLevel = _isDesktop ? 4 : 3;
      _zoomPanBehavior.minZoomLevel = _isDesktop ? 4 : 3;
    }

    return Stack(children: [
      Positioned.fill(
        child: Image.asset(
          'images/maps_grid.png',
          repeat: ImageRepeat.repeat,
        ),
      ),
      SfMapsTheme(
        data: SfMapsThemeData(
          shapeHoverColor: Colors.transparent,
        ),
        child: SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              initialMarkersCount: _markerData.length,
              zoomPanBehavior: _zoomPanBehavior,
              controller: _mapController,
              markerBuilder: (BuildContext context, int index) {
                return MapMarker(
                  latitude: _markerData[index].latLng.latitude,
                  longitude: _markerData[index].latLng.longitude,
                  child: index == 0
                      ? BlowingCircle(color: _layerColor)
                      : Icon(Icons.circle, color: _layerColor, size: 15),
                );
              },
              markerTooltipBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_markerData[index].country,
                      style: model.themeData.textTheme.caption!
                          .copyWith(color: Color.fromRGBO(255, 255, 255, 1))),
                );
              },
              tooltipSettings: MapTooltipSettings(
                color: Color.fromRGBO(45, 45, 45, 1),
              ),
              sublayers: [_getCurrentSublayer(_currentSublayer)],
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildChipWidget(0, 'New York'),
              _buildChipWidget(1, 'Denver'),
              _buildChipWidget(2, 'London'),
              _buildChipWidget(3, 'Dublin'),
              _buildChipWidget(4, 'Beijing'),
              _buildChipWidget(5, 'Delhi'),
              _buildChipWidget(6, 'Chennai'),
            ],
          ),
        ),
      )
    ]);
  }

  Widget _buildChipWidget(int index, String city) {
    return Padding(
      padding: _isDesktop
          ? const EdgeInsets.only(left: 8.0, top: 8.0)
          : const EdgeInsets.only(left: 8.0),
      child: ChoiceChip(
        backgroundColor: model.themeData.brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        elevation: 3.0,
        label: Text(
          city,
          style: TextStyle(
            color: model.textColor,
          ),
        ),
        selected: _currentSelectedCityIndex == index,
        onSelected: (bool isSelected) {
          if (isSelected) {
            setState(() {
              _currentSelectedCityIndex = index;
              _setNavigationLineData(_currentSelectedCityIndex);
              _zoomPanBehavior.focalLatLng = _markerData[0].latLng;
              _canUpdateZoomLevel = false;
              _animationController.forward(from: 0);
            });
          }
        },
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Layer type',
                      style: TextStyle(
                        color: model.textColor,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: DropdownButton(
                          value: _currentSublayer,
                          items: _dropDownMenuItems,
                          onChanged: (String? value) {
                            setState(() {
                              _currentSublayer = value!;
                              _canUpdateZoomLevel = false;
                            });
                            stateSetter(() {});
                          },
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Show dashes',
                        style: TextStyle(
                          color: model.textColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                        width: 90,
                        child: CheckboxListTile(
                            activeColor: model.backgroundColor,
                            value: _enableDashArray,
                            onChanged: (bool? value) {
                              setState(() {
                                _enableDashArray = value!;
                                _dashArray =
                                _enableDashArray ? [8, 2, 2, 2] : [0, 0];
                                _canUpdateZoomLevel = false;
                              });
                              stateSetter(() {});
                            })),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class _MarkerData {
  _MarkerData(this.country, this.latLng);

  String country;
  MapLatLng latLng;
}

class _AirRouteDetails {
  _AirRouteDetails(this.from, this.to, this.destination);

  MapLatLng from;
  MapLatLng to;
  String destination;
}

class _BlowingCircleCustomPaint extends CustomPainter {
  _BlowingCircleCustomPaint(
      {required this.iconColor,
        required this.iconSize,
        required this.animationValue});

  final Color iconColor;

  final Size iconSize;

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final double halfWidth = iconSize.width / 2;
    final Offset center = Offset(0.0, 0.0);
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = iconColor;
    canvas.drawCircle(center, halfWidth, paint);
    canvas.drawCircle(center, halfWidth + halfWidth * 2 * animationValue,
        paint..color = iconColor.withOpacity(1 - animationValue));
  }

  @override
  bool shouldRepaint(_BlowingCircleCustomPaint oldDelegate) => true;
}

/// Renders the blowing  circle sample
class BlowingCircle extends StatefulWidget {
  /// Creates the blowing  circle sample
  const BlowingCircle({
    Key? key,
    required this.color,
  }) : super(key: key);

  /// Color value
  final Color color;

  @override
  _BlowingCircleState createState() => _BlowingCircleState();
}

class _BlowingCircleState extends State<BlowingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    );

    _animation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: _controller,
    )..addListener(() {
      setState(() {});
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BlowingCircleCustomPaint(
          iconColor: widget.color,
          iconSize: Size(15.0, 15.0),
          animationValue: _animation.value),
    );
  }
}
