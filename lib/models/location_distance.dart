import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:dcc/models/location.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart' as gloc;

part 'location_distance.freezed.dart';

double distanceBetween(GeoPoint from, GeoPoint to) {
  if (from == null || to == null) {
    return null;
  }
  return gloc.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude
  );
}

List<LocationDistance> sortByDistance(GeoPoint from, List<Location> locations) {
  final location_distances = locations.map((l) {
    final distance = distanceBetween(from, l.geoPoint);
    return LocationDistance(location: l, distance: distance);
  }).toList();

  location_distances.sort((a, b) {
    final aDist = a.distance ?? double.maxFinite;
    final bDist = b.distance ?? double.maxFinite;
    return aDist.compareTo(bDist);
  });

  return location_distances;
}

@freezed
abstract class LocationDistance with _$LocationDistance {
  LocationDistance._();

  factory LocationDistance({
    final Location location,
    final double distance,
  }) = _LocationDistance;
}


