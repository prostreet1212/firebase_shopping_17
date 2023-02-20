// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
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
    apiKey: 'AIzaSyBh9XuQrKPvgiUWV-bP7OhKru1WhVuKJEA',
    appId: '1:930495165546:web:b4cb1a6f9ba3f96aafc613',
    messagingSenderId: '930495165546',
    projectId: 'fir-shopping17',
    authDomain: 'fir-shopping17.firebaseapp.com',
    storageBucket: 'fir-shopping17.appspot.com',
    measurementId: 'G-WQCR5R95GF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGw_lnG1-0itYE7FtDMwPzkFWgUwqtYOo',
    appId: '1:930495165546:android:3441bd88cb702eeeafc613',
    messagingSenderId: '930495165546',
    projectId: 'fir-shopping17',
    storageBucket: 'fir-shopping17.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJR9oVazAWu2YkvFrE75ng6XX-xyOuEvA',
    appId: '1:930495165546:ios:fc1e85e128535461afc613',
    messagingSenderId: '930495165546',
    projectId: 'fir-shopping17',
    storageBucket: 'fir-shopping17.appspot.com',
    androidClientId:
        '930495165546-gfoph9jvqbpbm41kpu9h62oe5qcmb8m2.apps.googleusercontent.com',
    iosClientId:
        '930495165546-988ubq43bn14tk8vprap2p72jlbr2drc.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseShopping17',
  );
}