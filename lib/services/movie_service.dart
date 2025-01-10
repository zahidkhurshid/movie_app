import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model.dart';
import '../config/app_settings.dart';

class MovieService extends ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _recommendations = [];
  List<String> _searchHistory = [];

  List<Movie> get movies => _movies;

  List<Movie> get popularMovies => _popularMovies;

  List<Movie> get topRatedMovies => _topRatedMovies;

  List<Movie> get upcomingMovies => _upcomingMovies;

  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  List<Movie> get recommendations => _recommendations;

  List<String> get searchHistory => _searchHistory;

  Future<void> fetchMoviesByCategory(String category) async {
    final response = await http.get(Uri.parse(
        '${AppSettings.apiBaseUrl}/movie/$category?api_key=${AppSettings.apiKey}'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      final List<Movie> detailedMovies = [];
      for (var movie in results) {
        final detailedMovie = await getMovieDetails(movie['id']);
        detailedMovies.add(detailedMovie);
      }
      switch (category) {
        case 'popular':
          _popularMovies = detailedMovies;
          break;
        case 'top_rated':
          _topRatedMovies = detailedMovies;
          break;
        case 'upcoming':
          _upcomingMovies = detailedMovies;
          break;
        case 'now_playing':
          _nowPlayingMovies = detailedMovies;
          break;
      }
      _movies = _popularMovies; // Default to popular movies
      notifyListeners();
    } else {
      throw Exception(AppSettings.networkErrorMessage);
    }
  }

  Future<void> fetchRecommendations(int movieId) async {
    if (!AppSettings.enableRecommendations) return;

    final response = await http.get(Uri.parse(
        '${AppSettings.apiBaseUrl}/movie/$movieId/recommendations?api_key=${AppSettings.apiKey}'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      _recommendations = results
          .map((movie) => Movie.fromJson(movie))
          .take(AppSettings.maxRecommendations)
          .toList();
      notifyListeners();
    } else {
      throw Exception(AppSettings.networkErrorMessage);
    }
  }

  Future<void> fetchAllCategories() async {
    await Future.wait([
      fetchMoviesByCategory('popular'),
      fetchMoviesByCategory('top_rated'),
      fetchMoviesByCategory('upcoming'),
      fetchMoviesByCategory('now_playing'),
    ]);
  }

  void updateMoviesByCategory(String category) {
    switch (category) {
      case 'Popular':
        _movies = _popularMovies;
        break;
      case 'Top Rated':
        _movies = _topRatedMovies;
        break;
      case 'Upcoming':
        _movies = _upcomingMovies;
        break;
      case 'Now Playing':
        _movies = _nowPlayingMovies;
        break;
    }
    notifyListeners();
  }

  MovieService() {
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _searchHistory = prefs.getStringList('searchHistory') ?? [];
    notifyListeners();
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', _searchHistory);
  }

  Future<void> addToSearchHistory(String query) async {
    if (!_searchHistory.contains(query)) {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory.removeLast();
      }
      await _saveSearchHistory();
      notifyListeners();
    }
  }

  Future<void> clearSearchHistory() async {
    _searchHistory.clear();
    await _saveSearchHistory();
    notifyListeners();
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(Uri.parse(
          '${AppSettings.apiBaseUrl}/search/movie?api_key=${AppSettings.apiKey}&query=$query'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        // Get detailed information for each movie
        final List<Movie> movies = [];
        for (var result in results) {
          try {
            final movieDetails = await getMovieDetails(result['id']);
            movies.add(movieDetails);
          } catch (e) {
            print('Error fetching details for movie ${result['id']}: $e');
            // Create a basic movie object if details fetch fails
            movies.add(Movie.fromJson(result));
          }
        }

        await addToSearchHistory(query);
        return movies;
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      print('Error in searchMovies: $e');
      rethrow;
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          '${AppSettings.apiBaseUrl}/movie/$movieId?api_key=${AppSettings.apiKey}&append_to_response=credits,similar'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Ensure genres are properly formatted
        data['genres'] = (data['genres'] as List)
            .map((genre) => genre['name'] as String)
            .toList();
        return Movie.fromJson(data);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      print('Error in getMovieDetails: $e');
      rethrow;
    }
  }

  Future<String?> getMovieTrailer(int movieId) async {
    final response = await http.get(Uri.parse(
        '${AppSettings.apiBaseUrl}/movie/$movieId/videos?api_key=${AppSettings.apiKey}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      final trailers = results
          .where((video) =>
              video['type'] == 'Trailer' && video['site'] == 'YouTube')
          .toList();

      if (trailers.isNotEmpty) {
        return 'https://www.youtube.com/watch?v=${trailers.first['key']}';
      }
    }
    return null;
  }
}
