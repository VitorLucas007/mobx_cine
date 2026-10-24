import 'package:mobx_cine/core/di/injection.dart';
import 'package:mobx_cine/core/routes/app_router.dart';
import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/core/theme/app_theme.dart';
import 'package:mobx_cine/core/theme/theme_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

Future<void> main() async {
  // Necessário antes de usar plugins (SharedPreferences) no main
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const CineApp());
}

class CineApp extends StatelessWidget {
  const CineApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeStore = getIt<ThemeStore>();

    // Quando o tema muda, o MaterialApp redesenha e o app inteiro troca de cor
    return Observer(
      builder: (_) => MaterialApp(
        title: 'Cine MobX',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeStore.themeMode,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
