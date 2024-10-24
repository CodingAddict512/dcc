import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/pages/map.dart';
import 'package:dcc/pages/pickups.dart';
import 'package:dcc/widgets/nav_fragment.dart';
import 'package:dcc/widgets/routes_driver_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;

  static List _navFragments = [
    PickupsPage(),
    MapPage(),
  ];

  void _onNewNav(index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _routesNavItem = BottomNavigationBarItem(
      icon: Icon(Icons.local_shipping),
      label:
          DccLocalizations.of(context)!.translate("homeNavigationLabelPickups"),
    );

    final _mapsNavItem = BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: DccLocalizations.of(context)!.translate("homeNavigationLabelMap"),
    );

    final _navBar = BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        _routesNavItem,
        _mapsNavItem,
      ],
      currentIndex: _selectedNavIndex,
      onTap: _onNewNav,
    );

    Widget body() {
      Widget fragment = _navFragments.elementAt(_selectedNavIndex);
      if ((fragment as NavFragment).fullPage) {
        return SafeArea(
          child: Stack(
            children: <Widget>[
              fragment,
              RoutesDriverBar(),
            ],
          ),
        );
      }
      return SafeArea(
        child: Column(
          children: <Widget>[
            RoutesDriverBar(),
            Divider(
              color: Colors.transparent,
            ),
            Expanded(
              child: fragment,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: null,
      body: body(),
      bottomNavigationBar: _navBar,
    );
  }
}
