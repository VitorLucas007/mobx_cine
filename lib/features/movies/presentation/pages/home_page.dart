import 'package:mobx_cine/core/di/injection.dart';
import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/core/theme/theme_store.dart';
import 'package:mobx_cine/core/utils/view_state.dart';
import 'package:mobx_cine/core/widgets/error_view.dart';
import 'package:mobx_cine/features/auth/presentation/stores/auth_store.dart';
import 'package:mobx_cine/features/movies/presentation/stores/movies_store.dart';
import 'package:mobx_cine/features/movies/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _store = getIt<MoviesStore>(); // nova store a cada Home (factory)
  final _auth = getIt<AuthStore>();    // a mesma de sempre (singleton)
  final _theme = getIt<ThemeStore>();

  @override
  void initState() {
    super.initState();
    _store.loadMovies(); // começa a buscar os filmes assim que a tela abre
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    // (_) => false remove TODAS as telas anteriores: depois de sair, "voltar" não reabre a home
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Em cartaz 🍿'),
        actions: [
          // Troca de tema: o ícone muda sozinho
          Observer(
            builder: (_) => IconButton(
              tooltip: 'Alternar tema',
              icon: Icon(_theme.isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: _theme.toggle,
            ),
          ),
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Observer(
                  builder: (_) => Text(
                    'Olá, ${_auth.user?.name.split(' ').first ?? ''}!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: _store.setQuery,
                  decoration: const InputDecoration(
                    hintText: 'Buscar filme...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          // Observer: redesenha só esta área quando o estado da store (state, filteredMovies) muda
          Expanded(child: Observer(builder: (_) => _buildBody())),
        ],
      ),
    );
  }

  /// Desenha a lista conforme o estado da store: carregando, erro ou sucesso.
  Widget _buildBody() {
    switch (_store.state) {
      case ViewState.initial:
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());

      case ViewState.error:
        return ErrorView(
          message: _store.errorMessage ?? 'Erro desconhecido',
          onRetry: _store.loadMovies,
        );

      case ViewState.success:
        final movies = _store.filteredMovies;
        if (movies.isEmpty) {
          return const Center(child: Text('Nenhum filme encontrado.'));
        }
        return RefreshIndicator(
          onRefresh: _store.loadMovies,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            // RESPONSIVO: cada card tem no máximo 220px de largura.
            // Celular → 2 colunas, tablet → 4, desktop → 6...
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              childAspectRatio: 0.58,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) => MovieCard(
              movie: movies[index],
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.details,
                arguments: movies[index],
              ),
            ),
          ),
        );
    }
  }
}
