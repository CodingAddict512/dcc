import 'package:dcc/models/location.dart';
import 'package:dcc/pages/location_search.dart';
import 'package:flutter/material.dart';

class LocationSelection extends StatelessWidget {
  final void Function(Location location) onSelection;
  final String title;
  final List<Location> locations;
  final List<Location> recent;

  LocationSelection({
    @required this.title,
    this.locations,
    this.recent,
    this.onSelection,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return InkWell(
      onTap: () async {
        final result = await navigator.push(
          MaterialPageRoute(builder: (BuildContext context) {
            return LocationSearch(
              locations: locations,
              recent: recent,
            );
          }),
        );

        if (result != null && result is Location) {
          onSelection(result);
        }
      },
      child: ListTile(
        leading: Icon(null),
        title: Text(title),
      ),
    );
  }
}
