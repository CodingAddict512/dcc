import 'package:dcc/dependencies_provider.dart';
import 'package:flutter/material.dart';

import 'dcc_app.dart';

void main() => runApp(ProdApp());

class ProdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return DependenciesProvider.fromChild(
      child: DccApp(),
    );
  }
}
