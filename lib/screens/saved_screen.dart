import 'package:flutter/material.dart';
import '../config/app_settings.dart';
import '../models/movie_model.dart';
import '../services/user_service.dart';
import 'movie_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final UserService _userService = UserService();
  List<Movie> _savedMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedMovies();
  }

  Future<void> _loadSavedMovies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await _userService.getFavoriteMovies();
      setState(() {
        _savedMovies = movies.cast<Movie>();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading saved movies: ${e.toString()}')),
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
        title: Text('Saved Movies'),
        backgroundColor: Color(0xFF0A0E21),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _savedMovies.isEmpty
          ? Center(child: Text('No saved movies', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: _savedMovies.length,
        itemBuilder: (context, index) {
          final movie = _savedMovies[index];
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

