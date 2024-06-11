///Dart import
import 'dart:async';

///Flutter package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the world clock marker map widget
class MapMarkerPage extends SampleView {
  /// Creates the world clock marker map widget
  const MapMarkerPage(Key key) : super(key: key);

  @override
  _MapMarkerPageState createState() => _MapMarkerPageState();
}

class _MapMarkerPageState extends SampleViewState {
  late List<Model> _data;
  late List<Widget> _iconsList;
  late MapShapeSource _dataSource;

  @override
  void initState() {
    _data = <Model>[
      Model(-14.235004, -51.92528),
      Model(51.16569, 10.451526),
      Model(-25.274398, 133.775136),
      Model(20.593684, 78.96288),
      Model(61.52401, 105.318756)
    ];

    _iconsList = <Widget>[
      Icon(Icons.add_location),
      Icon(Icons.airplanemode_active),
      Icon(Icons.add_alarm),
      Icon(Icons.accessibility_new),
      Icon(Icons.account_balance)
    ];

    _dataSource = MapShapeSource.asset(
      'assets/world_map.json',
      shapeDataField: 'name',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: SfMaps(
              layers: <MapLayer>[
                MapShapeLayer(
                  source: _dataSource,
                  initialMarkersCount: 5,
                  markerBuilder: (BuildContext context, int index) {
                    return MapMarker(
                      latitude: _data[index].latitude,
                      longitude: _data[index].longitude,
                      child: _iconsList[index],
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }


}
class Model {
  Model(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

// class _ClockWidget extends StatefulWidget {
//   const _ClockWidget({Key? key, required this.countryName, required this.date})
//       : super(key: key);
//
//   final String countryName;
//   final DateTime date;
//
//   @override
//   _ClockWidgetState createState() => _ClockWidgetState();
// }
//
// class _ClockWidgetState extends State<_ClockWidget> {
//   late String _currentTime;
//   late DateTime _date;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     _date = widget.date;
//     _currentTime = _getFormattedDateTime(widget.date);
//     _timer = Timer.periodic(
//         const Duration(seconds: 1), (Timer t) => _updateTime(_date));
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _timer = null;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Center(
//           child: Container(
//             width: 8,
//             height: 8,
//             decoration:
//                 const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 35),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 widget.countryName,
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText2!
//                     .copyWith(fontWeight: FontWeight.bold),
//               ),
//               Center(
//                 child: Text(_currentTime,
//                     style: Theme.of(context).textTheme.overline!.copyWith(
//                         letterSpacing: 0.5, fontWeight: FontWeight.w500)),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   void _updateTime(DateTime currentDate) {
//     _date = currentDate.add(const Duration(seconds: 1));
//     setState(() {
//       _currentTime = DateFormat('hh:mm:ss a').format(_date);
//     });
//   }
//
//   String _getFormattedDateTime(DateTime dateTime) {
//     return DateFormat('hh:mm:ss a').format(dateTime);
//   }
// }

class _TimeDetails {
  _TimeDetails(this.countryName, this.latitude, this.longitude, this.date);

  final String countryName;
  final double latitude;
  final double longitude;
  final DateTime date;
}
