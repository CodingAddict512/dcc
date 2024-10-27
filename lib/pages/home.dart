import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/pages/map.dart';
import 'package:dcc/pages/pickups.dart';
import 'package:dcc/widgets/routes_driver_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;

  static List<Widget> _pages = [
    PickupsPage(),

    MapPage(),
    // Center(),
  ];

  void _onNewNav(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    print("Home Page initialized");
  }

  @override
  Widget build(BuildContext context) {
    final localizations = DccLocalizations.of(context);
    if (localizations == null) {
      print("Localization not available");
      return Center(child: CircularProgressIndicator());
    }

    final _navBar = BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.local_shipping),
          label: localizations.translate("homeNavigationLabelPickups"),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map),
          label: localizations.translate("homeNavigationLabelMap"),
        ),
      ],
      currentIndex: _selectedNavIndex,
      onTap: _onNewNav,
    );

    Widget body() {
      Widget page = _pages[_selectedNavIndex];
      return SafeArea(
        child: Column(
          children: <Widget>[
            RoutesDriverBar(),
            const Divider(color: Colors.transparent),
            Expanded(child: page),
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
