import 'package:dcc/models/final_disposition.dart';
import 'package:flutter/material.dart';

class TypeSearchResults extends StatelessWidget {
  final List<FinalDisposition> results;
  final Function(FinalDisposition finalDisposition) onSelection;

  TypeSearchResults({@required this.results, this.onSelection});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Container();
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final t = results.elementAt(index);
        return InkWell(
          onTap: () async => this.onSelection(t),
          child: ListTile(
            leading: Icon(Icons.category),
            title: Text(t.type),
          ),
        );
      },
    );
  }
}
