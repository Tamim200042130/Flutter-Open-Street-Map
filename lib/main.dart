import 'package:flutter/material.dart';
import 'package:flutter_open_street_map/samples/maps/shape_layer/selection/selection.dart';
import 'package:flutter_open_street_map/samples/maps/shape_layer/sublayer/sublayer.dart';
import 'package:flutter_open_street_map/samples/maps/tile_layer/bing_map/bing_map.dart';
import 'package:flutter_open_street_map/samples/maps/tile_layer/open_street_map/open_street_map.dart';
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
      home: MapPolylinesPage(Key('poly-lines')),

      // home: const MapOSMPage(
      //   Key('osm'),
      // ),
      // home: const MapSublayerPage(
      //   Key('sublayer'),
      // ),
      // home: const MapSelectionPage(
      //   Key('selection'),
      // ),
    );
  }
}
