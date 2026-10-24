import 'package:mobx_cine/core/config/app_config.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterUrl,
    required super.rating,
    required super.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final posterPath = json['poster_path'] as String?;

    return MovieModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? 'Sem título',
      overview: (json['overview'] as String?) ?? '',
      posterUrl: posterPath == null ? null : '${AppConfig.tmdbImageUrl}$posterPath',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
      releaseDate: (json['release_date'] as String?) ?? '',
    );
  }
}
