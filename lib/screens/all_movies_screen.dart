import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../widgets/movie_list.dart';
import '../config/app_settings.dart';

class AllMoviesScreen extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const AllMoviesScreen({
    Key? key,
    required this.title,
    required this.movies,
  }) : super(key: key);

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

