import 'package:mobx_cine/features/movies/domain/entities/movie.dart';

/// CONTRATO (interface): diz O QUE se pode pedir sobre filmes, sem dizer COMO.
/// O domain só conhece este contrato. Quem faz o trabalho de verdade é o MovieRepositoryImpl (camada data).
/// Por isso dá para trocar a API por outra sem mexer nas regras nem nas telas.
abstract class MovieRepository {
  Future<List<Movie>> getNowPlaying();
}
