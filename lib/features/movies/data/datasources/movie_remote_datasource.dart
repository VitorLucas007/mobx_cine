import 'dart:async';
import 'dart:convert';

import 'package:mobx_cine/core/config/app_config.dart';
import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/features/movies/data/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieRemoteDataSource {
  MovieRemoteDataSource(this._client);

  final http.Client _client;

  Future<List<MovieModel>> getNowPlaying() async {
    if (AppConfig.tmdbApiKey.isEmpty) {
      throw const AppException(
        'Chave da API não configurada. Rode com --dart-define=TMDB_API_KEY=sua_chave',
      );
    }

    final uri = Uri.parse('${AppConfig.tmdbBaseUrl}/movie/now_playing').replace(
      queryParameters: {
        'api_key': AppConfig.tmdbApiKey,
        'language': 'pt-BR',
        'region': 'BR',
        'page': '1',
      },
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw AppException('Não foi possível buscar os filmes (erro ${response.statusCode}).');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final results = body['results'] as List;
      return results
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } on TimeoutException {
      throw const AppException('A conexão demorou demais. Tente novamente.');
    } on http.ClientException {
      throw const AppException('Sem conexão com a internet.');
    }
  }
}
