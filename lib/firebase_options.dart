// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJaReddlmwWuIShA1PolzHiD7VnyGWwP8',
    appId: '1:219899770182:web:898e45b106b38c06d5a147',
    messagingSenderId: '219899770182',
    projectId: 'demosocialapp-ef38c',
    authDomain: 'demosocialapp-ef38c.firebaseapp.com',
    storageBucket: 'demosocialapp-ef38c.firebasestorage.app',
    measurementId: 'G-8CDFMFC9P8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQzyt1fYF0WhIMgsl13NoXMOztcDyfjAk',
    appId: '1:219899770182:android:382cf87744ee69e1d5a147',
    messagingSenderId: '219899770182',
    projectId: 'demosocialapp-ef38c',
    storageBucket: 'demosocialapp-ef38c.firebasestorage.app',
  );
}
