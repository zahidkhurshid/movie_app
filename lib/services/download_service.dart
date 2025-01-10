import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model.dart';
import 'dart:convert';
import 'dart:math';

class DownloadService {
  static const String _downloadedMoviesKey = 'downloadedMovies';

  Future<List<Movie>> getDownloadedMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedMoviesJson = prefs.getString(_downloadedMoviesKey) ?? '[]';
    final List<dynamic> downloadedMoviesList =
        json.decode(downloadedMoviesJson);
    return downloadedMoviesList
        .map((movieJson) => Movie.fromJson(movieJson))
        .toList();
  }

  Future<void> downloadMovie(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedMoviesJson = prefs.getString(_downloadedMoviesKey) ?? '[]';
    final List<dynamic> downloadedMoviesList =
        json.decode(downloadedMoviesJson);

    if (!downloadedMoviesList.any((m) => m['id'] == movie.id)) {
      final movieWithFileSize = movie.toJson();
      movieWithFileSize['file_size'] = _generateRandomFileSize();
      downloadedMoviesList.add(movieWithFileSize);
      await prefs.setString(
          _downloadedMoviesKey, json.encode(downloadedMoviesList));
    }
  }

  Future<void> deleteDownloadedMovie(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedMoviesJson = prefs.getString(_downloadedMoviesKey) ?? '[]';
    final List<dynamic> downloadedMoviesList =
        json.decode(downloadedMoviesJson);

    downloadedMoviesList.removeWhere((movie) => movie['id'] == movieId);
    await prefs.setString(
        _downloadedMoviesKey, json.encode(downloadedMoviesList));
  }

  int _generateRandomFileSize() {
    final random = Random();
    // Generate a random file size between 500 MB and 2 GB
    return random.nextInt(1500 * 1024 * 1024) + 500 * 1024 * 1024;
  }
}
