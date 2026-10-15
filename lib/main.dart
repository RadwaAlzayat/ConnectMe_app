import 'package:connectme_app/Injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required before any async work in main
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupInjection(); // register dependencies before the app starts
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('ConnectMe'))),
    ),
  );
}
