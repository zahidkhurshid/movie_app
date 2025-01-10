import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../services/user_service.dart';
import '../services/movie_service.dart';
import '../config/app_settings.dart';
import '../providers/theme_provider.dart';
import 'movie_detail_screen.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  @override
  _FavoriteMoviesScreenState createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  final UserService _userService = UserService();
  final MovieService _movieService = MovieService();
  List<Movie> _favoriteMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
  }

  Future<void> _loadFavoriteMovies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favoriteMovieIds = await _userService.getFavoriteMovies();
      final movies = await Future.wait(
          favoriteMovieIds.map((id) => _movieService.getMovieDetails(id))
      );
      setState(() {
        _favoriteMovies = movies;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading favorite movies: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('Favorite Movies', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favoriteMovies.isEmpty
          ? Center(child: Text('No favorite movies', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)))
          : ListView.builder(
        itemCount: _favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = _favoriteMovies[index];
          return ListTile(
            leading: movie.posterUrl != null
                ? Image.network(
              movie.posterUrl!,
              width: 50,
              height: 75,
              fit: BoxFit.cover,
            )
                : Icon(Icons.movie, size: 50, color: themeProvider.isDarkMode ? Colors.white : Colors.grey),
            title: Text(movie.title, style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            subtitle: Text(
              movie.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: themeProvider.isDarkMode ? Colors.grey[300] : Colors.grey[600]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie: movie),
                ),
              ).then((_) => _loadFavoriteMovies());
            },
          );
        },
      ),
    );
  }
}

