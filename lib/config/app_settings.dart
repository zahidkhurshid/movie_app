import 'package:flutter/material.dart';

class AppSettings {
  // API Settings
  static const String apiBaseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '5f218e0dd8cac8f10b783c0dd99aa8f6';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // App-wide Settings
  static const String appName = 'MovieMaster';
  static const String appVersion = '1.0.0';

  // Feature Flags
  static const bool enableRecommendations = true;
  static const bool enableUserReviews = true;
  static const bool enableOfflineMode = false;

  // UI Settings
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  // Color Palette
  static const Color primaryColor = Colors.red;
  static const Color secondaryColor = Colors.blue;
  static const Color accentColor = Colors.amber;

  // Text Styles
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // Pagination
  static const int moviesPerPage = 20;
  static const int maxPagesToLoad = 5;

  // Caching
  static const Duration cacheDuration = Duration(hours: 24);
  static const int maxCachedMovies = 100;

  // Review Settings
  static const int maxReviewLength = 500;
  static const double minRating = 0.5;
  static const double maxRating = 5.0;
  static const double ratingStep = 1.0;
  static const double iconSize = 24.0;

  // Recommendation Settings
  static const int maxRecommendations = 10;
  static const double similarityThreshold = 0.7;

  // Error Messages
  static const String genericErrorMessage =
      'An error occurred. Please try again.';
  static const String networkErrorMessage =
      'Network error. Please check your internet connection.';
  static const String authErrorMessage =
      'Authentication failed. Please log in again.';

  // Localization
  static const Locale defaultLocale = Locale('en', 'US');
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
  ];
}
