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
    apiKey: 'AIzaSyDOCAbC123456789_YOUR_API_KEY_HERE',
    appId: '1:123456789:web:abcdef123456789',
    messagingSenderId: '123456789',
    projectId: 'music-player-123456',
    authDomain: 'music-player-123456.firebaseapp.com',
    storageBucket: 'music-player-123456.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOCAbC123456789_YOUR_API_KEY_HERE',
    appId: '1:123456789:android:abcdef123456789',
    messagingSenderId: '123456789',
    projectId: 'music-player-123456',
    storageBucket: 'music-player-123456.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOCAbC123456789_YOUR_API_KEY_HERE',
    appId: '1:123456789:ios:abcdef123456789',
    messagingSenderId: '123456789',
    projectId: 'music-player-123456',
    storageBucket: 'music-player-123456.appspot.com',
    iosBundleId: 'com.example.musicPlayer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDOCAbC123456789_YOUR_API_KEY_HERE',
    appId: '1:123456789:macos:abcdef123456789',
    messagingSenderId: '123456789',
    projectId: 'music-player-123456',
    storageBucket: 'music-player-123456.appspot.com',
    iosBundleId: 'com.example.musicPlayer',
  );
}
