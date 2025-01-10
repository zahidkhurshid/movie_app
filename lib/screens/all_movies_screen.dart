import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../widgets/movie_list.dart';

class AllMoviesScreen extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const AllMoviesScreen({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color(0xFF0A0E21),
      ),
      body: MovieList(movies: movies),
    );
  }
}
