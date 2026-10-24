import 'package:mobx_cine/core/theme/theme_store.dart';
import 'package:mobx_cine/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:mobx_cine/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobx_cine/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobx_cine/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mobx_cine/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobx_cine/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mobx_cine/features/auth/domain/usecases/register_usecase.dart';
import 'package:mobx_cine/features/auth/presentation/stores/auth_store.dart';
import 'package:mobx_cine/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:mobx_cine/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/movies/domain/repositories/movie_repository.dart';
import 'package:mobx_cine/features/movies/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:mobx_cine/features/movies/presentation/stores/movies_store.dart';
import 'package:mobx_cine/features/tickets/data/datasources/ticket_local_datasource.dart';
import 'package:mobx_cine/features/tickets/data/repositories/ticket_repository_impl.dart';
import 'package:mobx_cine/features/tickets/domain/repositories/ticket_repository.dart';
import 'package:mobx_cine/features/tickets/domain/usecases/get_occupied_seats_usecase.dart';
import 'package:mobx_cine/features/tickets/domain/usecases/purchase_ticket_usecase.dart';
import 'package:mobx_cine/features/tickets/presentation/stores/seat_selection_store.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  // ───── Externos / globais ─────
  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<http.Client>(http.Client())
    ..registerSingleton<ThemeStore>(ThemeStore(prefs));

  // ───── Auth ─────
  getIt
    ..registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource(getIt()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()))
    ..registerFactory(() => LoginUseCase(getIt()))
    ..registerFactory(() => RegisterUseCase(getIt()))
    ..registerFactory(() => GetCurrentUserUseCase(getIt()))
    ..registerFactory(() => LogoutUseCase(getIt()))
    // Singleton: a sessão é a mesma no app inteiro
    ..registerLazySingleton<AuthStore>(() => AuthStore(getIt(), getIt(), getIt(), getIt()));

  // ───── Movies ─────
  getIt
    ..registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSource(getIt()))
    ..registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(getIt()))
    ..registerFactory(() => GetNowPlayingMoviesUseCase(getIt()))
    // Factory: estado novo a cada vez que a Home abre
    ..registerFactory<MoviesStore>(() => MoviesStore(getIt()));

  // ───── Tickets ─────
  getIt
    ..registerLazySingleton<TicketLocalDataSource>(() => TicketLocalDataSource(getIt()))
    ..registerLazySingleton<TicketRepository>(() => TicketRepositoryImpl(getIt()))
    ..registerFactory(() => GetOccupiedSeatsUseCase(getIt()))
    ..registerFactory(() => PurchaseTicketUseCase(getIt()))
    // FactoryParam: recebe o filme escolhido
    ..registerFactoryParam<SeatSelectionStore, Movie, void>(
      (movie, _) => SeatSelectionStore(movie, getIt(), getIt()),
    );
}
