import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/movie_service.dart';
import 'theme/app_theme.dart';
import 'config/app_settings.dart';
import 'config/firebase_settings.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseSettings.firebaseOptions,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    if (e.toString().contains('duplicate-app')) {
      print('Firebase app already initialized');
    } else {
      rethrow;
    }
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: AppSettings.appName,
      theme:
          themeProvider.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: HomeScreen(),
      supportedLocales: AppSettings.supportedLocales,
      localizationsDelegates: [
        // Add your localization delegates here
      ],
    );
  }
}
