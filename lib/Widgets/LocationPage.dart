import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LocationPage extends StatefulWidget {
  // final String name;
  final GeoPoint geo;

  @override
  _LocationPageState createState() => _LocationPageState();

  LocationPage(this.geo);
}

//                'https://www.google.ae/maps/@33.5103767,36.2924112,18z',
// correct form :http://maps.google.com/maps?q=24.197611,120.780512
//https://stackoverflow.com/questions/5807063/url-to-a-google-maps-page-to-show-a-pin-given-a-latitude-longitude
class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    // print(widget.url);
    return Material(
      child: WebviewScaffold(
        appBar: AppBar(
          title: Text(
            "ِAddress|عنوان",
          ),
          centerTitle: true,
        ),
        url:
            "http://maps.google.ae/maps?q=${widget.geo.latitude},${widget.geo.longitude}",
        withJavascript: true,
        withZoom: true,
      ),
    );
  }
}
