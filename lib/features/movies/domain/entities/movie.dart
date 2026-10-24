class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.rating,
    required this.releaseDate,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterUrl; // pode não ter pôster
  final double rating;
  final String releaseDate;
}
