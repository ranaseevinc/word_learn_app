
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAPB14e_j0498aPOQmLW8H2t31VnLopGxM',
    appId: '1:205361994737:web:1e4faaedb004c787004250',
    messagingSenderId: '205361994737',
    projectId: 'fir-app-82358',
    authDomain: 'fir-app-82358.firebaseapp.com',
    databaseURL: 'https://fir-app-82358-default-rtdb.firebaseio.com',
    storageBucket: 'fir-app-82358.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfvC9sZUQaCKDsvEz0XPX0HZNqNsd-lLc',
    appId: '1:205361994737:android:a93397ab4e8cd81b004250',
    messagingSenderId: '205361994737',
    projectId: 'fir-app-82358',
    databaseURL: 'https://fir-app-82358-default-rtdb.firebaseio.com',
    storageBucket: 'fir-app-82358.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdxsVHU8sdMYQ4cPTEUZWLvIauDV8w1Fc',
    appId: '1:205361994737:ios:8d18a7f04d361566004250',
    messagingSenderId: '205361994737',
    projectId: 'fir-app-82358',
    databaseURL: 'https://fir-app-82358-default-rtdb.firebaseio.com',
    storageBucket: 'fir-app-82358.firebasestorage.app',
    iosBundleId: 'com.example.firebaseApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAdxsVHU8sdMYQ4cPTEUZWLvIauDV8w1Fc',
    appId: '1:205361994737:ios:8d18a7f04d361566004250',
    messagingSenderId: '205361994737',
    projectId: 'fir-app-82358',
    databaseURL: 'https://fir-app-82358-default-rtdb.firebaseio.com',
    storageBucket: 'fir-app-82358.firebasestorage.app',
    iosBundleId: 'com.example.firebaseApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAPB14e_j0498aPOQmLW8H2t31VnLopGxM',
    appId: '1:205361994737:web:e341845aebae0eab004250',
    messagingSenderId: '205361994737',
    projectId: 'fir-app-82358',
    authDomain: 'fir-app-82358.firebaseapp.com',
    databaseURL: 'https://fir-app-82358-default-rtdb.firebaseio.com',
    storageBucket: 'fir-app-82358.firebasestorage.app',
  );

}