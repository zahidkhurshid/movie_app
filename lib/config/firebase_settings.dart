import 'package:firebase_core/firebase_core.dart';

class FirebaseSettings {
  static const String apiKey = "Your API Key";
  static const String authDomain =
      "my-movie-recommendation-app.firebaseapp.com";
  static const String projectId = "my-movie-recommendation-app";
  static const String storageBucket = "my-movie-recommendation-app.appspot.com";
  static const String messagingSenderId = "messagingSenderId";
  static const String appId = "appId";

  static const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: apiKey,
    authDomain: authDomain,
    projectId: projectId,
    storageBucket: storageBucket,
    messagingSenderId: messagingSenderId,
    appId: appId,
  );

  // Firestore collection names
  static const String usersCollection = "users";
  static const String moviesCollection = "movies";
  static const String reviewsCollection = "reviews";

  // Storage paths
  static const String userAvatarsPath = "user_avatars";
  static const String moviePostersPath = "movie_posters";

  // Authentication settings
  static const int passwordMinLength = 8;
  static const bool emailVerificationRequired = true;

  // Firestore caching settings
  static const bool offlinePersistenceEnabled = true;
  static const int cacheSizeBytes = 10485760; // 10 MB

  // Cloud Functions region
  static const String cloudFunctionsRegion = "us-central1";
}
