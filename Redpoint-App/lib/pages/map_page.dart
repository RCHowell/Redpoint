import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:red_point/locations.dart';
import 'package:geolocator/geolocator.dart';


class MapPage extends StatefulWidget {

  final int wallId;

  MapPage(this.wallId);

  @override
  State createState() => _MapPageState(wallId);
}

class _MapPageState extends State<MapPage> {
  final double swLng = -83.85;
  final double swLat = 37.63;
  final double neLng = -83.49;
  final double neLat = 37.91;
  final int wallId;

  LatLng currentLocation;
  Timer locTimer;

  _MapPageState(this.wallId);

  @override initState() {
    locTimer = Timer.periodic(Duration(seconds: 5), (_) => updateCurrentLocation());
    super.initState();
  }

  void updateCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (validPosition(position)) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    } else {
      print(position.toString());
      print('Position is invalid!');
      // Cancel timer to avoid unwanted calls to GPS
      locTimer.cancel();
    }

  }

  bool validPosition(Position pos) {
    if (pos == null) return false;
    // Check it is in the longitude range
    if (pos.longitude <= swLng || neLng <= pos.longitude) return false;
    // Check it is in the latitude range
    if (pos.latitude <= swLat || neLat <= pos.latitude) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double cLng = (swLng + neLng) / 2;
    double cLat = (swLat + neLat) / 2;
    double markerSize = 50.0;

    List<Marker> markers = locations.keys.map((key) {
      var loc = locations[key];
      return Marker(
        width: markerSize,
        height: markerSize,
        builder: (_) => _cragButton(markerSize, loc['name'].toString(), key),
        point: LatLng(loc['lat'], loc['lng']),
      );
    }).toList();

    if (currentLocation != null) {
      markers.add(Marker(
        point: currentLocation,
        width: 20.0,
        height: 20.0,
        builder: (_) => Icon(Icons.my_location, color: Colors.blue),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(cLat, cLng),
          minZoom: 10.0,
          maxZoom: 17.0,
          zoom: 10.0,
          swPanBoundary: LatLng(swLat, swLng),
          nePanBoundary: LatLng(neLat, neLng),
        ),
        layers: [
          TileLayerOptions(
//            offlineMode: true,
            maxZoom: 15.0,
//            urlTemplate: "assets/map/{z}/{x}/{y}.png",
            urlTemplate: "https://tile.thunderforest.com/landscape/{z}/{x}/{y}.png?apikey=aecdbbdbb6cb4f28911f56508baf9170",
          ),
          MarkerLayerOptions(
            markers: markers,
          ),
        ],
      ),
    );
  }

  Widget _cragButton(double size, String label, int id) {
    return Container(
      height: size,
      child: Column(
        children: <Widget>[
//          RawMaterialButton(
//            onPressed: () {
//              print("YO!");
//            },
//            child: Icon(
//              Icons.adjust,
//              color: Colors.white,
//              size: size - 12.0,
//            ),
//            shape: CircleBorder(),
//            elevation: 2.0,
//            fillColor: Colors.redAccent,
//          ),
          Icon(
            Icons.adjust,
            color: (wallId == id) ? Colors.redAccent : Colors.black,
            size: size - 35.0,
          ),
          Expanded(
            child: FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }

}
