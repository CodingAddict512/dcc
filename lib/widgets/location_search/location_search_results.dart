import 'dart:math';

import 'package:dcc/models/location.dart';
import 'package:dcc/models/location_distance.dart';
import 'package:flutter/material.dart';

class LocationSearchResults extends StatelessWidget {
  static const show_max_results = 5;

  final List<LocationDistance> results;
  final Function(Location location) onSelection;

  LocationSearchResults({@required this.results, this.onSelection});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Container(); //TODO: Show recent
    }

    return ListView.builder(
      itemCount: min(show_max_results, results.length),
      itemBuilder: (context, index) {
        final ld = results.elementAt(index);
        return InkWell(
          onTap: () => this.onSelection(ld.location),
          child: ListTile(
            leading: Icon(Icons.place),
            title: Text(ld.location.name),
          ),
        );
      },
    );
  }
}
