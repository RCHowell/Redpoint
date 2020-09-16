import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:red_point/locations.dart';
import 'package:red_point/pages/map_page.dart';

class MiniMap extends StatelessWidget {
  final int wallId;

  MiniMap(this.wallId);

  @override
  Widget build(BuildContext context) {
    Map loc = locations[wallId];
    if (loc == null) return Text('No Location Data');
    LatLng center = LatLng(loc['lat'], loc['lng']);

    return FlutterMap(
      options: MapOptions(
          center: center,
          zoom: 11.0,
          interactive: false,
          onTap: (_) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => MapPage(wallId)));
          }),
      layers: [
        TileLayerOptions(
          tileProvider: AssetTileProvider(),
          urlTemplate: "assets/map/{z}/{x}/{y}.png",
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              builder: (_) {
                return Icon(
                  Icons.adjust,
                  size: 30.0,
                  color: Colors.redAccent,
                );
              },
              width: 30.0,
              height: 30.0,
              point: center,
            )
          ],
        ),
      ],
    );
  }
}
