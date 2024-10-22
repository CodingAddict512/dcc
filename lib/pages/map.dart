import 'dart:math';

import 'package:dcc/cubits/geo_location_cubit.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/extensions/geo_point_conversion.dart';
import 'package:dcc/extensions/status.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/widgets/nav_fragment.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:geolocator_platform_interface/src/errors/permission_denied_exception.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class MapPage extends StatefulWidget implements NavFragment {
  @override
  final bool fullPage = true;

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng currLocation = null;

  Widget loading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final pickupsCubit = context.watch<PickupsCubit>();
    final geoLocationCubit = context.watch<GeoLocationCubit>();

    Future<LatLng> getAndUpdateCurrLocation() async {
      try {
        LatLng newCurrLocation = (await geoLocationCubit.getCurrentGeoPosition())?.toGoogleMapsLatLng;
        if (mounted) {
          setState(() {
            currLocation = newCurrLocation;
          });
        }
        return newCurrLocation;
      } on PermissionDeniedException {
        FlushbarHelper.createError(
          message: DccLocalizations.of(context).translate("mapPageLocationPermissionDenied"),
          duration: Duration(seconds: 3),
        ).show(context);
      }
      return null;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (currLocation == null) {
        getAndUpdateCurrLocation();
      }
    });

    if (currLocation == null) {
      return loading();
    }

    final initialCameraPosition = CameraPosition(
      target: currLocation,
      zoom: 19,
    );

    void _onMapCreated(GoogleMapController mapController) {
      if (mounted) {
        final mapMarkerHelper = MapMarkerHelper(mapController);
        pickupsCubit.state.ifState<PickupsLoaded>(
          withState: (state) async {
            if (mounted) {
              mapMarkerHelper.refreshMarkersFromPickupsAndMoveCamera(
                state.pickups,
                currLocation: await getAndUpdateCurrLocation(),
              );
            }
          },
        );
        pickupsCubit.stream.listen((state) async {
          if (state is PickupsLoaded && mounted) {
            mapMarkerHelper.refreshMarkersFromPickupsAndMoveCamera(
              state.pickups,
              currLocation: await getAndUpdateCurrLocation(),
            );
          }
        });
      }
    }

    GoogleMap _googleMaps = GoogleMap(
      initialCameraPosition: initialCameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: _onMapCreated,
      padding: EdgeInsets.only(top: 64.0),
    );

    return Scaffold(
      body: _googleMaps,
    );
  }
}

class MapMarkerHelper {
  GoogleMapController _mapController;
  Set<Marker> _markers = Set();

  MapMarkerHelper(GoogleMapController mapController) {
    _mapController = mapController;
  }

  void refreshMarkersFromPickups(List<Pickup> pickups) async {
    Set<Marker> newMarkers = _markersFromPickups(pickups);
    GoogleMapsFlutterPlatform.instance.updateMarkers(
      MarkerUpdates.from(_markers, newMarkers),
      mapId: _mapController.mapId,
    );
    _markers = newMarkers;
  }

  void refreshMarkersFromPickupsAndMoveCamera(List<Pickup> pickups, {LatLng currLocation}) async {
    refreshMarkersFromPickups(pickups);
    List<LatLng> coords = pickups.map((p) => p.originLocation.geoPoint.toGoogleMapsLatLng).toList();
    if (currLocation != null) {
      coords.add(currLocation);
    }
    moveCameraToShow(coords);
  }

  void moveCameraToShow(Iterable<LatLng> coords) {
    if (coords.isEmpty) {
      return;
    }
    // Calculate bounding box with northeast corner being highest coordinates
    // and southwest corner being lowest coordinates
    final minLatitude = coords.map((c) => c.latitude).reduce(min);
    final maxLatitude = coords.map((c) => c.latitude).reduce(max);
    final minLongitude = coords.map((c) => c.longitude).reduce(min);
    final maxLongitude = coords.map((c) => c.longitude).reduce(max);
    LatLng northEastCorner = LatLng(maxLatitude, maxLongitude);
    LatLng southWestCorner = LatLng(minLatitude, minLongitude);
    LatLngBounds bounds = LatLngBounds(
      southwest: southWestCorner,
      northeast: northEastCorner,
    );
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  Set<Marker> _markersFromPickups(List<Pickup> pickups) {
    return pickups
        .map((p) => Marker(
              markerId: MarkerId(p.id),
              position: p.originLocation.geoPoint.toGoogleMapsLatLng,
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(
                title: "📍   ${p.originCustomer.name}}",
                snippet: "${p.status.name()}   ${p.deadline}",
              ),
            ))
        .toSet();
  }
}
