import 'package:mobx_cine/core/di/injection.dart';
import 'package:mobx_cine/core/routes/app_router.dart';
import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/core/theme/app_theme.dart';
import 'package:mobx_cine/core/theme/theme_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// PONTO DE ENTRADA: é a primeira função que roda quando o app abre.
Future<void> main() async {
  // Necessário antes de usar plugins (SharedPreferences) no main
  WidgetsFlutterBinding.ensureInitialized();
  // Cria e registra todas as dependências (stores, repositórios, etc.) antes de abrir a primeira tela
  await setupDependencies();
  runApp(const CineApp());
}

/// Widget raiz: configura tema, rota inicial e o mapa de rotas.
class CineApp extends StatelessWidget {
  const CineApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeStore = getIt<ThemeStore>();

    // Quando o tema muda, o MaterialApp redesenha e o app inteiro troca de cor
    return Observer(
      builder: (_) => MaterialApp(
        title: 'MobxCine',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeStore.themeMode,
        initialRoute: AppRoutes.splash, // o app sempre começa pela splash
        // Toda navegação por nome passa por aqui para descobrir qual tela abrir
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
