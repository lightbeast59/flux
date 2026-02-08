import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyA-rMwx_ddKGHv1A3d_KsGFa9x8ZkKxVn4',
          appId: '1:133693046891:web:3df7bed58f2d8b117b312e',
          messagingSenderId: '133693046891',
          projectId: 'flux3task',
          authDomain: 'flux3task.firebaseapp.com',
          storageBucket: 'flux3task.firebasestorage.app',
          measurementId: 'G-91KP0C7YHE',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  }
}
