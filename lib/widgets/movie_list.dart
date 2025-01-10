import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../config/app_settings.dart';
import '../screens/movie_detail_screen.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return AnimatedOpacity(
            duration: AppSettings.mediumAnimationDuration,
            opacity: 1.0,
            child: TweenAnimationBuilder(
              duration: AppSettings.mediumAnimationDuration,
              tween: Tween<double>(begin: 1.0, end: 1.0),
              builder: (BuildContext context, double scale, Widget? child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: ListTile(
                contentPadding: EdgeInsets.all(AppSettings.defaultPadding),
                leading: Hero(
                  tag: 'movie-${movie.id}',
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSettings.defaultBorderRadius),
                    child: Image.network(
                        movie.posterUrl ??
                            'https://example.com/default_image.png',
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover),
                  ),
                ),
                title: Text(movie.title, style: AppSettings.headlineStyle),
                subtitle: Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppSettings.bodyStyle,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
