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

  List<Movie> get movies => _movies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get recommendations => _recommendations;

  Future<void> fetchMoviesByCategory(String category) async {
    final response = await http.get(
        Uri.parse('${AppSettings.apiBaseUrl}/movie/$category?api_key=${AppSettings.apiKey}')
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      switch (category) {
        case 'popular':
          _popularMovies = results.map((movie) => Movie.fromJson(movie)).toList();
          break;
        case 'top_rated':
          _topRatedMovies = results.map((movie) => Movie.fromJson(movie)).toList();
          break;
        case 'upcoming':
          _upcomingMovies = results.map((movie) => Movie.fromJson(movie)).toList();
          break;
        case 'now_playing':
          _nowPlayingMovies = results.map((movie) => Movie.fromJson(movie)).toList();
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

    final response = await http.get(
        Uri.parse('${AppSettings.apiBaseUrl}/movie/$movieId/recommendations?api_key=${AppSettings.apiKey}')
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      _recommendations = results.map((movie) => Movie.fromJson(movie)).take(AppSettings.maxRecommendations).toList();
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

  List<String> _searchHistory = [];

  List<String> get searchHistory => _searchHistory;

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
    final response = await http.get(
        Uri.parse('${AppSettings.apiBaseUrl}/search/movie?api_key=${AppSettings.apiKey}&query=$query')
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      await addToSearchHistory(query);
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception(AppSettings.networkErrorMessage);
    }
  }
}

