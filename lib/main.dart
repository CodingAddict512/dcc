import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/dependencies_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dcc_app.dart';

// void main() => runApp(ProdApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyA0oRNdU9lijtUrpcyyDHa6ZqCV6dDWBwU',
        appId: '1:1020733915446:android:8dca93b62812b65e5c3397',
        messagingSenderId: '1020733915446',
        projectId: 'dcc-demo-environment'),
  );
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(ProdApp());
}

class ProdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return DependenciesProvider.fromChild(
      child: DccApp(),
    );
  }
}
