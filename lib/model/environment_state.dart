import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

enum EnvironmentState {
  prod(
    environmentName: 'prod',
    firebaseName: 'perthgang-wordle',
    firebaseAuthPersistence: Persistence.LOCAL,
    firebaseAppCheckWebRecaptchaSiteKey:
        '6LeYIjIhAAAAAIKQ-SwT6sDe6q_cGUSPTZ8FQyCz',
    firebaseOptions: FirebaseOptions(
      apiKey: 'AIzaSyDEgadgd-37be4MgIMokV_XpDgr9iskUtQ',
      appId: '1:951244738282:web:e8d46fe0729b0fac89d193',
      messagingSenderId: '951244738282',
      projectId: 'perthgang-wordle',
      authDomain: 'perthgang-wordle.firebaseapp.com',
      storageBucket: 'perthgang-wordle.appspot.com',
    ),
  ),
  stage(
    environmentName: 'stage',
    firebaseName: 'perthle-stage',
    firebaseAuthPersistence: Persistence.SESSION,
    firebaseAppCheckWebRecaptchaSiteKey: null,
    firebaseOptions: FirebaseOptions(
      apiKey: 'AIzaSyAIwu6tIc5h5Z1evzoS81izUPlFVK-3BK0',
      authDomain: 'perthle-stage.firebaseapp.com',
      projectId: 'perthle-stage',
      storageBucket: 'perthle-stage.appspot.com',
      messagingSenderId: '1028603132539',
      appId: '1:1028603132539:web:e171352221c5f0b6a5c0de',
    ),
  );

  const EnvironmentState({
    required this.environmentName,
    required this.firebaseName,
    required this.firebaseAuthPersistence,
    required this.firebaseAppCheckWebRecaptchaSiteKey,
    required this.firebaseOptions,
  });

  final String environmentName;
  final String firebaseName;
  final Persistence firebaseAuthPersistence;
  final String? firebaseAppCheckWebRecaptchaSiteKey;
  final FirebaseOptions firebaseOptions;

  factory EnvironmentState.fromEnvVars() {
    if (const String.fromEnvironment('ENV') == 'prod') {
      return EnvironmentState.prod;
    } else {
      return EnvironmentState.stage;
    }
  }
}
