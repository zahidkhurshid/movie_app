import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/user_service.dart';
import '../config/app_settings.dart';
import 'movie_detail_screen.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  @override
  _FavoriteMoviesScreenState createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  final UserService _userService = UserService();
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
      final movies = await _userService.getFavoriteMovies();
      setState(() {
        _favoriteMovies = movies.cast<Movie>();
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
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text('Favorite Movies'),
        backgroundColor: Color(0xFF0A0E21),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favoriteMovies.isEmpty
          ? Center(child: Text('No favorite movies', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: _favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = _favoriteMovies[index];
          return ListTile(
            leading: Image.network(
              '${AppSettings.imageBaseUrl}${movie.posterPath}',
              width: 50,
              height: 75,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.movie, size: 50, color: Colors.grey),
            ),
            title: Text(movie.title, style: TextStyle(color: Colors.white)),
            subtitle: Text(
              movie.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

