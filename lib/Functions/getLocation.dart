import 'package:flutter/material.dart';
import 'package:location/location.dart';

Future<LocationData> getLocation(BuildContext context) async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      var snackbar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text("please enable location service")),
            Expanded(child: Text("رجاء فعل خدمة الموقع")),
          ],
        ),
        duration: Duration(milliseconds: 1000),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      var snackbar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text("Please Allow Location Permission")),
            Expanded(child: Text("رجاء اقبل صلاحية الموقع ")),
          ],
        ),
        duration: Duration(milliseconds: 1000),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  _locationData = await location.getLocation();

  return _locationData;
}
