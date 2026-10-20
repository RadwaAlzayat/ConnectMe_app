import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'injection.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await setupInjection();
    runApp(const ConnectMeApp());
  } catch (error) {
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text('$error')))));
  }
}