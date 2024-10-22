import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension GeoPointConversion on Position {
  GeoPoint get toGeoPoint => GeoPoint(this.latitude, this.longitude);
}

extension GeoCoordinatesConversion on GeoPoint {
  LatLng get toGoogleMapsLatLng => LatLng(this.latitude ?? 0, this.longitude ?? 0);
}
