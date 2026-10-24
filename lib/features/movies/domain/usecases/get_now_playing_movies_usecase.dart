import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/movies/domain/repositories/movie_repository.dart';

class GetNowPlayingMoviesUseCase {
  const GetNowPlayingMoviesUseCase(this._repository);

  final MovieRepository _repository;

  Future<List<Movie>> call() => _repository.getNowPlaying();
}
