import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_settings.dart';
import '../providers/theme_provider.dart';
import '../services/movie_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final movieService = Provider.of<MovieService>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode',
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black)),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeColor: AppSettings.primaryColor,
          ),
          ListTile(
            title: Text('Clear Search History',
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black)),
            onTap: () async {
              await movieService.clearSearchHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Search history cleared')),
              );
            },
          ),
          ListTile(
            title: Text('Privacy Policy',
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black)),
            onTap: () {
              // TODO: Navigate to privacy policy screen
            },
          ),
          ListTile(
            title: Text('Terms of Service',
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black)),
            onTap: () {
              // TODO: Navigate to terms of service screen
            },
          ),
          ListTile(
            title: Text('App Version',
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black)),
            trailing: Text(AppSettings.appVersion,
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.grey[300]
                        : Colors.grey[600])),
          ),
        ],
      ),
    );
  }
}
