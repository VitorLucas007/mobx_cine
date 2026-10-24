import 'package:mobx_cine/core/di/injection.dart';
import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/features/auth/presentation/stores/auth_store.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _decideRoute();
  }

  Future<void> _decideRoute() async {
    final auth = getIt<AuthStore>();
    await auth.checkSession();
    await Future.delayed(const Duration(milliseconds: 800));

    // Depois de um "await", sempre confira se a tela ainda existe
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      auth.isLoggedIn ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_filter_rounded, size: 80, color: scheme.primary),
            const SizedBox(height: 16),
            Text('Cine MobX', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
