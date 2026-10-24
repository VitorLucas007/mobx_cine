import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/features/auth/presentation/pages/login_page.dart';
import 'package:mobx_cine/features/auth/presentation/pages/resgister_page.dart';
import 'package:mobx_cine/features/auth/presentation/pages/splash_page.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/movies/presentation/pages/home_page.dart';
import 'package:mobx_cine/features/movies/presentation/pages/movie_details_page.dart';
import 'package:mobx_cine/features/tickets/presentation/pages/result_page.dart';
import 'package:mobx_cine/features/tickets/presentation/pages/seat_selection_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoutes.splash => const SplashPage(),
      AppRoutes.login => const LoginPage(),
      AppRoutes.register => const RegisterPage(),
      AppRoutes.home => const HomePage(),
      AppRoutes.details => MovieDetailsPage(movie: settings.arguments as Movie),
      AppRoutes.seats => SeatSelectionPage(movie: settings.arguments as Movie),
      AppRoutes.result => ResultPage(args: settings.arguments as ResultArgs),
      _ => const Scaffold(body: Center(child: Text('Página não encontrada'))),
    };

    // Passar "settings" mantém o nome da rota (usado no popUntil)
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}
