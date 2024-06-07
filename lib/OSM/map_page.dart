import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_street_map/OSM/widget/map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: const Text(
              'Map Page',
              style: TextStyle(color: Colors.white),
            ),
          )),
      body: MapWidget(),
    );
  }
}
