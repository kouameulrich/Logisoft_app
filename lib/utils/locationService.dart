// ignore_for_file: unnecessary_new, no_leading_underscores_for_local_identifiers, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class LocationService {
  CollectionReference docRapport =
      FirebaseFirestore.instance.collection('rapport');

  sendLocationToDataBase(context) async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    final docRapport = FirebaseFirestore.instance.collection('rapport').doc();
    docRapport.update({
      'latitude': _locationData.latitude,
      'longitude': _locationData.longitude,
    });
  }
}
