import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/cubits/geo_location_cubit.dart';
import 'package:dcc/cubits/primary_locations_cubit.dart';
import 'package:dcc/cubits/states/default_locations_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/customer_stub.dart';
import 'package:dcc/widgets/customer_search/customer_search_results.dart';
// import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class CustomerSearch extends StatefulWidget {
  final List<CustomerStub> customers;
  final List<CustomerStub> recent;
  final bool isReceiver;

  CustomerSearch({
    this.customers = const [],
    this.recent = const [],
    this.isReceiver = false,
  });

  @override
  State<StatefulWidget> createState() => CustomerSearchState(isReceiver);
}

class CustomerSearchState extends State<CustomerSearch> {
  final _searchController = TextEditingController();
  final bool isReceiver;

  GeoPoint? _currLocation;
  bool _permissionRequested = false;
  List<CustomerStub> searchResults = [];

  CustomerSearchState(this.isReceiver);

  Widget loading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final geoLocationCubit = context.watch<GeoLocationCubit>();
    final localization = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    Future<List<CustomerStub>> search(String query) async {
      final primaryLocationsCubit = context.watch<PrimaryLocationsCubit>();
      return primaryLocationsCubit.state.ifState<PrimaryLocationsLoaded>(
        withState: (state) async {
          // If location permission denied or haven't received current location yet, show all customers
          Iterable<CustomerStub> filtered = state.locations.where((l) {
            return l.customerName.toLowerCase().contains(query.toLowerCase());
          });
          List<PrimaryLocationDistance> sorted =
              primaryLocationsCubit.sortByDistance(_currLocation!, filtered);

          // If customer receiver, show all customers
          if (isReceiver) {
            return sorted.map((dld) => dld.primaryLocation).toList();
          }

          return sorted.map((dld) => dld.primaryLocation).toList();
        },
        orElse: (state) => <CustomerStub>[],
      );
    }

    final newResults = () async {
      final results = await search(_searchController.text);
      if (mounted) {
        setState(() {
          searchResults = results;
        });
      }
    };

    _searchController.addListener(newResults);

    Future<GeoPoint> getAndUpdateCurrLocation() async {
      try {
        GeoPoint newCurrLocation =
            await geoLocationCubit.getCurrentGeoPosition();
        if (mounted) {
          setState(() {
            _currLocation = newCurrLocation;
          });
          newResults();
        }
        return newCurrLocation;
      } on PermissionDeniedException {
        // FlushbarHelper.createError(
        //   message: localization.translate("customerSearchLocationPermissionDenied"),
        //   duration: Duration(seconds: 3),
        // ).show(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localization!
                .translate("customerSearchLocationPermissionDenied")),
            duration: Duration(seconds: 3),
          ),
        );
      } on LocationServiceDisabledException {
        // FlushbarHelper.createError(
        //   message: localization.translate("customerSearchLocationServiceDisabled"),
        //   duration: Duration(seconds: 3),
        // ).show(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localization!
                .translate("customerSearchLocationServiceDisabled")),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return null as GeoPoint;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_permissionRequested) {
        _permissionRequested = true;
        getAndUpdateCurrLocation();
      }
    });

    Widget searchField() {
      return TextFormField(
        maxLines: null,
        controller: _searchController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: DccLocalizations.of(context)!
              .translate("customerSearchSearchFieldHint"),
          border: InputBorder.none,
        ),
        autofocus: true,
      );
    }

    Widget clearSearchFieldButton() {
      return IconButton(
        splashRadius: 1,
        icon: Icon(Icons.clear),
        onPressed: () {
          _searchController.text = "";
        },
        tooltip: DccLocalizations.of(context)!
            .translate("customerSearchClearTooltip"),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: searchField(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                clearSearchFieldButton(),
              ],
            ),
          )
        ],
      ),
      body: CustomerSearchResults(
        results: searchResults,
        onSelection: (c) => navigator.pop(c),
      ),
    );
  }
}
