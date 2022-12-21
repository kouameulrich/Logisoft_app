// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationScreen extends StatefulWidget {
  LatLng latLng;
  CurrentLocationScreen({Key? key, required this.latLng}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;
  late CameraPosition initialCameraPosition;
  late Set<Marker> markers;

  @override
  void initState() {
    markers = {
      Marker(
        markerId: MarkerId('Enregistrement'),
        position: widget.latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      )
    };
    initialCameraPosition = CameraPosition(target: widget.latLng, zoom: 14);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.terrain,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
    );
  }
}
