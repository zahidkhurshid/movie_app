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
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'] ?? '',
      genres: List<String>.from(json['genres']?.map((genre) => genre['name']) ?? []),
      runtime: json['runtime'] ?? 0,
      fileSize: json['file_size'] ?? 0,
      releaseDate: DateTime.parse(json['release_date']),
    );
  }

  // posterUrl getter
  String? get posterUrl {
    if (posterPath.isEmpty) {
      return null; // Return null if posterPath is empty
    }
    const baseUrl = 'https://image.tmdb.org/t/p/w500'; // Example base URL for TMDb images
    return '$baseUrl$posterPath';
  }

  // Getter for backdropUrl
  String? get backdropUrl {
    if (backdropPath.isEmpty) {
      return null;
    }
    const baseUrl = 'https://image.tmdb.org/t/p/w500';  // Same base URL as poster
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

