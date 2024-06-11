import 'package:flutter/foundation.dart';

import 'samples/maps/shape_layer/bubble/bubble.dart';
import 'samples/maps/shape_layer/equal_color_mapping/equal_color_mapping.dart';
import 'samples/maps/shape_layer/legend/legend.dart';
import 'samples/maps/shape_layer/marker/marker.dart';
import 'samples/maps/shape_layer/range_color_mapping/range_color_mapping.dart';
import 'samples/maps/shape_layer/selection/selection.dart';
import 'samples/maps/shape_layer/sublayer/sublayer.dart';
import 'samples/maps/shape_layer/tooltip/tooltip.dart';
import 'samples/maps/shape_layer/zooming/zooming.dart';
import 'samples/maps/tile_layer/bing_map/bing_map.dart';
import 'samples/maps/tile_layer/open_street_map/open_street_map.dart';
import 'samples/maps/tile_layer/vector_layer/arcs.dart';
import 'samples/maps/tile_layer/vector_layer/polygon.dart';
import 'samples/maps/tile_layer/vector_layer/polylines.dart';

/// Contains the output widget of sample
/// appropriate key and output widget mapped
Map<String, Function> getSampleWidget() {
  return <String, Function>{




    // Maps: Shape Layer Samples
    'range_color_mapping': (Key key) => MapRangeColorMappingPage(key),

    'equal_color_mapping': (Key key) => MapEqualColorMappingPage(key),

    'bubble': (Key key) => MapBubblePage(key),

    'selection': (Key key) => MapSelectionPage(key),

    'marker': (Key key) => MapMarkerPage(key),

    'legend': (Key key) => MapLegendPage(key),

    'tooltip': (Key key) => MapTooltipPage(key),

    'zooming': (Key key) => MapZoomingPage(key),

    'sublayer': (Key key) => MapSublayerPage(key),

    // Maps: Tile Layer Samples
    'open_street_map': (Key key) => MapOSMPage(key),

    'bing_map': (Key key) => MapBingPage(key),

    'arcs': (Key key) => MapArcsPage(key),

    'polylines': (Key key) => MapPolylinesPage(key),

    'polygon': (Key key) => MapPolygonPage(key),



  };
}
