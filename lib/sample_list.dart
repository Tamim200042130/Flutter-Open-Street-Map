import 'package:flutter/foundation.dart';


import 'samples/maps/shape_layer/marker/marker.dart';
import 'samples/maps/tile_layer/open_street_map/open_street_map.dart';
import 'samples/maps/tile_layer/vector_layer/polylines.dart';

/// Contains the output widget of sample
/// appropriate key and output widget mapped
Map<String, Function> getSampleWidget() {
  return <String, Function>{




    // Maps: Shape Layer Samples


    'marker': (Key key) => MapMarkerPage(key),



    // Maps: Tile Layer Samples
    'open_street_map': (Key key) => MapOSMPage(key),


    'polylines': (Key key) => MapPolylinesPage(),





  };
}
