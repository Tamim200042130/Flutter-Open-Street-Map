import 'package:flutter/material.dart';
import 'package:flutter_open_street_map/samples/maps/tile_layer/vector_layer/polylines.dart';

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
      home: MapPolylinesPage(),
      // home: const MapOSMPage(
      //   Key('osm'),
      // ),
      // home: const MapMarkerPage(
      //   Key('marker'),
      // ),
    );
  }
}
