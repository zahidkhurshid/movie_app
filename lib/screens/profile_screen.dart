import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../config/app_settings.dart';
import '../widgets/custom_bottom_nav.dart';
import '../services/navigation_service.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';
import 'favorite_movies_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'saved_screen.dart';
import 'downloads_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _currentUser == null
          ? Center(
        child: ElevatedButton(
          child: Text('Log In'),
          style: ElevatedButton.styleFrom(
            backgroundColor: themeProvider.isDarkMode ? Colors.blue : Colors.red,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: _currentUser?.photoURL != null
                    ? Image.network(
                  _currentUser!.photoURL!,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/default_avatar.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _currentUser?.displayName ?? 'User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _currentUser?.email ?? '',
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.isDarkMode ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            _buildProfileOption(
              icon: Icons.favorite,
              title: 'Favorite Movies',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteMoviesScreen()),
              ),
              themeProvider: themeProvider,
            ),
            _buildProfileOption(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ),
              themeProvider: themeProvider,
            ),
            _buildProfileOption(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpSupportScreen()),
              ),
              themeProvider: themeProvider,
            ),
            _buildProfileOption(
              icon: Icons.exit_to_app,
              title: 'Log Out',
              onTap: () async {
                await _authService.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              themeProvider: themeProvider,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index != _selectedIndex) {
            switch (index) {
              case 0:
                NavigationService.navigateToPage(context, HomeScreen());
                break;
              case 1:
                NavigationService.navigateToPage(context, SearchScreen());
                break;
              case 2:
                NavigationService.navigateToPage(context, SavedScreen());
                break;
              case 3:
                NavigationService.navigateToPage(context, DownloadsScreen());
                break;
            }
          }
        },
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeProvider themeProvider,
  }) {
    return ListTile(
      leading: Icon(icon, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
      title: Text(
        title,
        style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
      ),
      onTap: onTap,
    );
  }
}

