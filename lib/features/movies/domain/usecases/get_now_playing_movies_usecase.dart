import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/movies/domain/repositories/movie_repository.dart';

/// CASO DE USO: uma única ação do app → "buscar os filmes em cartaz".
/// Aqui poderiam entrar regras (filtros, ordenação). Hoje só repassa o pedido ao repositório.
class GetNowPlayingMoviesUseCase {
  const GetNowPlayingMoviesUseCase(this._repository);

  final MovieRepository _repository;

  // "call" permite usar o objeto como função: getNowPlaying()
  Future<List<Movie>> call() => _repository.getNowPlaying();
}
