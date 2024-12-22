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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCA5DLfovkaNqqeTbwGiwPRamf6GDuuiVs',
    appId: '1:60210194962:web:29987345cb9b9cf75906cb',
    messagingSenderId: '60210194962',
    projectId: 'classification-9a57f',
    authDomain: 'classification-9a57f.firebaseapp.com',
    storageBucket: 'classification-9a57f.firebasestorage.app',
    measurementId: 'G-YDZTTZHF0Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMrzDxk8t10VymuxUYQPLjcU0jVYECSS0',
    appId: '1:60210194962:android:443496e4945ddf2d5906cb',
    messagingSenderId: '60210194962',
    projectId: 'classification-9a57f',
    storageBucket: 'classification-9a57f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeTiA5QDudMc45TiO-l6ZzPyfGrDR_gmc',
    appId: '1:60210194962:ios:cfffc84d3a96aa235906cb',
    messagingSenderId: '60210194962',
    projectId: 'classification-9a57f',
    storageBucket: 'classification-9a57f.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAeTiA5QDudMc45TiO-l6ZzPyfGrDR_gmc',
    appId: '1:60210194962:ios:cfffc84d3a96aa235906cb',
    messagingSenderId: '60210194962',
    projectId: 'classification-9a57f',
    storageBucket: 'classification-9a57f.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCA5DLfovkaNqqeTbwGiwPRamf6GDuuiVs',
    appId: '1:60210194962:web:b89563f768f1c7fc5906cb',
    messagingSenderId: '60210194962',
    projectId: 'classification-9a57f',
    authDomain: 'classification-9a57f.firebaseapp.com',
    storageBucket: 'classification-9a57f.firebasestorage.app',
    measurementId: 'G-LXPZ7BRV4L',
  );
}
