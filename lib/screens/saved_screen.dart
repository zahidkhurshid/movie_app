import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/user_service.dart';
import '../services/movie_service.dart';
import '../widgets/custom_bottom_nav.dart';
import 'movie_detail_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'downloads_screen.dart';
import 'profile_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final UserService _userService = UserService();
  final MovieService _movieService = MovieService();
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
      final bookmarkedMovieIds = await _userService.getBookmarkedMovies();
      final movies = await Future.wait(
          bookmarkedMovieIds.map((id) => _movieService.getMovieDetails(id)));
      setState(() {
        _savedMovies = movies;
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
              ? Center(
                  child: Text('No saved movies',
                      style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  itemCount: _savedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = _savedMovies[index];
                    return ListTile(
                      leading: movie.posterUrl != null
                          ? Image.network(
                              movie.posterUrl!,
                              width: 50,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.movie,
                                      size: 50, color: Colors.grey),
                            )
                          : Icon(Icons.movie, size: 50, color: Colors.grey),
                      title: Text(movie.title,
                          style: TextStyle(color: Colors.white)),
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
                            builder: (context) =>
                                MovieDetailScreen(movie: movie),
                          ),
                        ).then((_) => _loadSavedMovies());
                      },
                    );
                  },
                ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index != 2) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadsScreen()),
                );
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
                break;
            }
          }
        },
      ),
    );
  }
}
