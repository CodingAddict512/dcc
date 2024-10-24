import 'dart:io';

import 'package:dcc/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanNhDocDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    final localizations = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    Widget cameraPicture() {
      return ListTile(
        leading: Icon(Icons.add_a_photo),
        onTap: () async {
          // final image = await picker.getImage(source: ImageSource.camera);
          final image = await picker.pickImage(source: ImageSource.camera);
          if (image != null) {
            navigator.pop(File(image.path));
          }
        },
        title: Text(localizations!.translate("scanNhDocDialogTakeAPicture")),
      );
    }

    Widget galleryPicture() {
      return ListTile(
        leading: Icon(Icons.add_photo_alternate),
        onTap: () async {
          // final image = await picker.getImage(source: ImageSource.gallery);
          final image = await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            navigator.pop(File(image.path));
          }
        },
        title: Text(localizations!.translate("scanNhDocDialogFromGallery")),
      );
    }

    return AlertDialog(
      content: Container(
        width: double.minPositive,
        child: ListView(
          shrinkWrap: true,
          children: [
            cameraPicture(),
            galleryPicture(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => navigator.pop(),
          child: Text(localizations!.translate("scanNhDocCancel")),
        ),
      ],
    );
  }
}
