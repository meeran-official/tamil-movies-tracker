class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      overview: map['overview'],
      posterPath: map['poster_path'] ?? '',
      // The API gives a number that can be an int or double, so we cast it
      voteAverage: (map['vote_average'] as num).toDouble(), // <-- ADD THIS LINE
    );
  }

  // Helper function to get the full image URL
  String get fullPosterPath {
    if (posterPath.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    // Return a placeholder image if no poster is available
    return 'https://via.placeholder.com/500x750?text=No+Image';
  }
}