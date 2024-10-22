import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/extensions/geo_point_conversion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocationCubit extends Cubit {
  final LocationAccuracy desiredAccuracy;
  GeoLocationCubit({this.desiredAccuracy = LocationAccuracy.best})
      : super(null);

  Future<GeoPoint> getCurrentGeoPosition() async {
    final position = await getCurrentPosition(desiredAccuracy: desiredAccuracy);
    return position.toGeoPoint;
  }
}
