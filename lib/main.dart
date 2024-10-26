// import 'package:dcc/dependencies_provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'dcc_app.dart';

// void main() {
//   runApp(ProdApp());
// }

// class ProdApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Firebase.initializeApp(), // Initialize Firebase here
//       builder: (context, snapshot) {
//         // Check for initialization errors
//         if (snapshot.connectionState == ConnectionState.done) {
//           return DependenciesProvider.fromChild(
//             child: DccApp(), // This will contain your main application setup
//           );
//         }

//         // While the Firebase is initializing, show a loading spinner
//         return Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }

import 'package:dcc/dependencies_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dcc_app.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(ProdApp());
}

class ProdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DependenciesProvider.fromChild(
      child: DccApp(), // This will contain your main application setup
    );
  }
}
