import 'package:cloud_firestore/cloud_firestore.dart';

/// SINGLETON PATTERN: only one FirestoreService exists for the whole app
/// lifecycle, so every data source shares the same Firestore connection.
///
/// How it works:
///  1. the private constructor `_internal()` stops anyone from creating more;
///  2. `_instance` is created once, the first time the class is used;
///  3. the `factory` constructor always returns that same `_instance`.
class FirestoreService {
  FirestoreService._internal();

  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }
}
