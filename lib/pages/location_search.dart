import 'package:dcc/cubits/geo_location_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/location_distance.dart';
import 'package:dcc/pages/current_location_edit.dart';
import 'package:dcc/widgets/location_search/location_search_results.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';

class LocationSearch extends StatefulWidget {
  final List<Location> locations;
  final List<Location> recent;

  LocationSearch({
    this.locations = const [],
    this.recent = const [],
  });

  @override
  State<StatefulWidget> createState() => LocationSearchState();
}

class LocationSearchState extends State<LocationSearch> {
  final _searchController = TextEditingController();

  List<LocationDistance> searchResults = [];

  @override
  Widget build(BuildContext context) {
    final geoLocationCubit = context.watch<GeoLocationCubit>();
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    Future<List<LocationDistance>> search(String query) async {
      if (widget.locations.length == 0) {
        return [];
      }
      final filtered = widget.locations.where((l) {
        //TODO: Sort by relevance
        return l.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      final location = await geoLocationCubit.getCurrentGeoPosition();

      return location != null ? sortByDistance(location, filtered) : filtered;
    }

    _searchController.addListener(() async {
      final results = await search(_searchController.text);
      if (mounted) {
        setState(() => searchResults = results);
      }
    });

    Widget currentLocation() {
      return InkWell(
        onTap: () async {
          final result = await navigator.push(MaterialPageRoute(
            builder: (context) => CurrentLocationEdit(),
          ));
          if (result is Location) {
            navigator.pop(result);
          }
        },
        child: ListTile(
          leading: Icon(Icons.my_location),
          title: Text(localizations.translate("locationSearchYourLocation")),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          keyboardType: TextInputType.name,
          autofocus: true,
        ),
      ),
      body: Column(
        children: [
          currentLocation(),
          Divider(color: Colors.grey),
          Expanded(
            child: LocationSearchResults(
              results: searchResults,
              onSelection: (l) => navigator.pop(l),
            ),
          ),
        ],
      ),
    );
  }
}
