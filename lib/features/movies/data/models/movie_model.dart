import 'package:mobx_cine/core/config/app_config.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';

/// MODEL: um Movie que sabe nascer a partir do JSON da API.
/// Fica na camada data porque o formato do JSON é um detalhe da API, não do app.
class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterUrl,
    required super.rating,
    required super.releaseDate,
  });

  /// Converte um item do JSON do TMDB em MovieModel.
  /// Os "?? valor" são valores padrão: se a API mandar null, o app não quebra.
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final posterPath = json['poster_path'] as String?;

    return MovieModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? 'Sem título',
      overview: (json['overview'] as String?) ?? '',
      // A API manda só o final do caminho; montamos a URL completa da imagem
      posterUrl: posterPath == null ? null : '${AppConfig.tmdbImageUrl}$posterPath',
      // vote_average pode vir como int ou double, por isso lemos como num
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
      releaseDate: (json['release_date'] as String?) ?? '',
    );
  }
}
