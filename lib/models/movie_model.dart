class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final List<String> genres;
  final int runtime;
  final int fileSize;
  final DateTime releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.genres,
    required this.runtime,
    required this.fileSize,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Handle potential null or invalid release date
    DateTime parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) {
        return DateTime.now(); // Default to current date if no date provided
      }
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        print('Invalid date format: $dateStr');
        return DateTime.now(); // Default to current date if parsing fails
      }
    }

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      runtime: json['runtime'] ?? 0,
      fileSize: json['file_size'] ?? 0,
      releaseDate: parseDate(json['release_date']),
    );
  }

  String? get posterUrl {
    if (posterPath.isEmpty) {
      return null;
    }
    const baseUrl = 'https://image.tmdb.org/t/p/w500';
    return '$baseUrl$posterPath';
  }

  String? get backdropUrl {
    if (backdropPath.isEmpty) {
      return null;
    }
    const baseUrl = 'https://image.tmdb.org/t/p/w500';
    return '$baseUrl$backdropPath';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'genres': genres,
      'runtime': runtime,
      'file_size': fileSize,
      'release_date': releaseDate.toIso8601String(),
    };
  }
}

