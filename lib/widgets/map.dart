import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final Completer<GoogleMapController> _controller = Completer();

  MapSample(
      {Key? key, this.latitude = 0, this.longitude = 0, this.zoom = 14.4746})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CameraPosition _markerPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: zoom,
    );

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _markerPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
