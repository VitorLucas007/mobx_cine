class AppConfig {
  // A chave vem de fora: flutter run --dart-define=TMDB_API_KEY=xxxx
  static const tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');
  static const tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const tmdbImageUrl = 'https://image.tmdb.org/t/p/w500';
}
