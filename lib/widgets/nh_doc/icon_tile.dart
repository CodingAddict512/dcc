import 'package:dcc/style/dcc_text_styles.dart';
import 'package:flutter/material.dart';

class IconTile extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;

  IconTile({this.icon, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: DccTextStyles.iconTile.title,
          ),
          Text(
            description,
            style: DccTextStyles.iconTile.description,
          )
        ],
      ),
    );
  }
}
