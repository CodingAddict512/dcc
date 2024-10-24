import 'package:dcc/cubits/geo_location_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
// import 'package:uuid/uuid_util.dart';
import 'package:dcc/extensions/compat.dart';

class CurrentLocationEdit extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  CurrentLocationEdit({String title = ""}) {
    _titleController.text = title;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    Widget titleInput() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          autofocus: true,
          keyboardType: TextInputType.text,
          controller: _titleController,
          decoration: InputDecoration(
            hintText:
                localizations!.translate("currentLocationEditTitleHintText"),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return localizations.translate("currentLocationEditEnterTitle");
            }
            return null;
          },
        ),
      );
    }

    Widget locationInfo() {
      return ListTile(
        leading: Icon(Icons.my_location),
        title: Text(localizations!
            .translate("currentLocationEditCurrentLocationLabel")),
      );
    }

    Widget doneButton() {
      return ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final id = Uuid().v4();
            final geoLocationCubit = context.watch<GeoLocationCubit>();
            final geoPoint = await geoLocationCubit.getCurrentGeoPosition();

            final location = Location(
              id: id,
              name: _titleController.text,
              geoPoint: geoPoint,
            );
            navigator.pop(location);
          }
        },
        child: Text(localizations!.translate("currentLocationEditDone")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                doneButton(),
              ],
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            titleInput(),
            Divider(color: Colors.grey),
            locationInfo(),
          ],
        ),
      ),
    );
  }
}
