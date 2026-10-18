import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required before async work
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupInjection(); // register services/repositories before the UI starts
  runApp(const ConnectMeApp());
}
