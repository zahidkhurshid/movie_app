import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_settings.dart';
import '../providers/theme_provider.dart';
import '../services/movie_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final movieService = Provider.of<MovieService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeColor: AppSettings.primaryColor,
          ),
          ListTile(
            title: Text('Clear Search History', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            onTap: () async {
              await movieService.clearSearchHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Search history cleared')),
              );
            },
          ),
          ListTile(
            title: Text('Privacy Policy', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            onTap: () {
              // TODO: Navigate to privacy policy screen
            },
          ),
          ListTile(
            title: Text('Terms of Service', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            onTap: () {
              // TODO: Navigate to terms of service screen
            },
          ),
          ListTile(
            title: Text('App Version', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            trailing: Text(AppSettings.appVersion, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
          ),
        ],
      ),
    );
  }
}

