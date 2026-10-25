import 'package:mobx_cine/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/movies/domain/repositories/movie_repository.dart';

/// Implementação do contrato MovieRepository.
/// Decide de onde vêm os dados. Aqui é só da API (datasource remoto);
/// se um dia houvesse cache local, a escolha entre os dois ficaria nesta classe.
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._remote);

  final MovieRemoteDataSource _remote;

  @override
  Future<List<Movie>> getNowPlaying() => _remote.getNowPlaying();
}
