import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocationCubit extends Cubit {
  final LocationAccuracy desiredAccuracy;
  GeoLocationCubit({this.desiredAccuracy = LocationAccuracy.best})
      : super(null);

  // Future<GeoPoint> getCurrentGeoPosition() async {
  //   final position = await getCurrentPosition(desiredAccuracy: desiredAccuracy);
  //   return position.toGeoPoint;
  // }
  Future<GeoPoint> getCurrentGeoPosition() async {
    // Call Geolocator.getCurrentPosition directly
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: desiredAccuracy,
    );

    // Return GeoPoint using the position's latitude and longitude
    return GeoPoint(position.latitude, position.longitude);
  }
}
