import 'package:mobx_cine/features/movies/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlaying();
}
