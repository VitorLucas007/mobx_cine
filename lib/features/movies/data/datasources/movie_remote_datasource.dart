import 'dart:async';
import 'dart:convert';

import 'package:mobx_cine/core/config/app_config.dart';
import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/features/movies/data/models/movie_model.dart';
import 'package:http/http.dart' as http;

/// DATASOURCE REMOTO: a única classe que fala com a internet (API do TMDB).
/// Ela só busca e converte; não decide nada sobre o app.
class MovieRemoteDataSource {
  MovieRemoteDataSource(this._client);

  final http.Client _client;

  Future<List<MovieModel>> getNowPlaying() async {
    // Falha cedo: sem chave a API recusaria o pedido, então avisamos o motivo real
    if (AppConfig.tmdbApiKey.isEmpty) {
      throw const AppException(
        'Chave da API não configurada. Rode com --dart-define=TMDB_API_KEY=sua_chave',
      );
    }

    // Monta o endereço final, algo como:
    // https://api.themoviedb.org/3/movie/now_playing?api_key=...&language=pt-BR&region=BR&page=1
    final uri = Uri.parse('${AppConfig.tmdbBaseUrl}/movie/now_playing').replace(
      queryParameters: {
        'api_key': AppConfig.tmdbApiKey, // quem está pedindo
        'language': 'pt-BR', // títulos e sinopses em português
        'region': 'BR', // filmes em cartaz no Brasil
        'page': '1', // primeira página de resultados
      },
    );

    try {
      // GET com limite de tempo: se a rede travar, não espera para sempre
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));

      // 200 = deu certo. Qualquer outro número é erro (401 = chave inválida, 404, 500...)
      if (response.statusCode != 200) {
        throw AppException('Não foi possível buscar os filmes (erro ${response.statusCode}).');
      }

      // O corpo chega como texto; jsonDecode transforma em Map. A lista de filmes está em "results".
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final results = body['results'] as List;
      // Cada item do JSON vira um MovieModel
      return results
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on AppException {
      // Já é um erro com mensagem pronta: só repassa, sem trocar a mensagem
      rethrow;
    } on TimeoutException {
      throw const AppException('A conexão demorou demais. Tente novamente.');
    } on http.ClientException {
      throw const AppException('Sem conexão com a internet.');
    }
  }
}
