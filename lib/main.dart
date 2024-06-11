import 'package:flutter/material.dart';
import 'package:flutter_open_street_map/samples/maps/shape_layer/marker/marker.dart';
import 'package:flutter_open_street_map/samples/maps/tile_layer/open_street_map/open_street_map.dart';
import 'package:flutter_open_street_map/samples/maps/tile_layer/vector_layer/polylines.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const MapPolylinesPage(
        Key('polylines'),
      ),
      // home: const MapOSMPage(
      //   Key('osm'),
      // ),
      // home: const MapMarkerPage(
      //   Key('marker'),
      // ),
    );
  }
}
