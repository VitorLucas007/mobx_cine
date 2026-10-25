import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/core/utils/view_state.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/movies/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:mobx/mobx.dart';

part 'movies_store.g.dart';

/// STORE (MobX): guarda o estado da tela Home e as ações que o alteram.
/// A tela não busca dados: ela chama a store e se redesenha quando o estado muda.
// Esta linha junta a classe base com o código gerado em movies_store.g.dart
class MoviesStore = _MoviesStoreBase with _$MoviesStore;

abstract class _MoviesStoreBase with Store {
  _MoviesStoreBase(this._getNowPlaying);

  final GetNowPlayingMoviesUseCase _getNowPlaying;

  @observable
  ViewState state = ViewState.initial;

  @observable
  String? errorMessage;

  @observable
  String query = '';

  // Para listas, use ObservableList: o MobX percebe add/remove/clear.
  final ObservableList<Movie> movies = ObservableList<Movie>();

  /// Computed: recalcula sozinho quando "movies" OU "query" mudam.
  @computed
  List<Movie> get filteredMovies {
    final text = query.trim().toLowerCase();
    if (text.isEmpty) return movies.toList();
    return movies.where((m) => m.title.toLowerCase().contains(text)).toList();
  }

  @action
  void setQuery(String value) => query = value;

  /// Busca os filmes e atualiza o estado: loading → success (ou error).
  @action
  Future<void> loadMovies() async {
    state = ViewState.loading;
    errorMessage = null;
    try {
      final result = await _getNowPlaying();
      movies
        ..clear()
        ..addAll(result);
      state = ViewState.success;
    } on AppException catch (e) {
      // Erro conhecido: já vem com mensagem amigável
      errorMessage = e.message;
      state = ViewState.error;
    } catch (_) {
      // Qualquer outro erro inesperado
      errorMessage = 'Algo deu errado ao carregar os filmes.';
      state = ViewState.error;
    }
  }
}
