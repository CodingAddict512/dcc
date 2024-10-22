import 'package:dcc/dcc_app.dart';
import 'package:flutter/material.dart';

import 'test_dependencies_provider.dart';

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TestDependenciesProvider(
      child: DccApp(),
    );
  }
}
