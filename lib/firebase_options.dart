// FILE: lib/firebase_options.dart (NEWLY ADDED)
// =======================================================================
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
    apiKey: "AIzaSyASSt-rtIWTOTW7SNO7kRsq76BhhGEWOhg",
    authDomain: "staffapp-des3113.firebaseapp.com",
    projectId: "staffapp-des3113",
    storageBucket: "staffapp-des3113.appspot.com",
    messagingSenderId: "611881038291",
    appId: "1:611881038291:web:c5d776e011583369abbf26",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:
        'your_android_api_key', // Placeholder, will use google-services.json
    appId: '1:611881038291:android:your_hash', // Placeholder
    messagingSenderId: '611881038291',
    projectId: 'staffapp-des3113',
  );
}
