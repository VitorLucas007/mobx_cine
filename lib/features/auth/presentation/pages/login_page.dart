import 'package:mobx_cine/core/di/injection.dart';
import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/core/utils/validators.dart';
import 'package:mobx_cine/core/widgets/primary_button.dart';
import 'package:mobx_cine/core/widgets/responsive_body.dart';
import 'package:mobx_cine/features/auth/presentation/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = getIt<AuthStore>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Estado SÓ DESTA TELA (mostrar/ocultar senha): setState resolve bem.
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // Limpa erros antigos DEPOIS do primeiro desenho da tela.
    // (Mudar observables durante o build causa erro no Flutter.)
    WidgetsBinding.instance.addPostFrameCallback((_) => _auth.clearError());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _auth.login(_emailController.text, _passwordController.text);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 420,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.movie_filter_rounded, size: 72, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Bem-vindo de volta!',
                        textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('Entre para comprar seus ingressos',
                        textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 16),

                    // Observer SÓ em volta do que muda com o MobX
                    Observer(
                      builder: (_) => _auth.errorMessage == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                _auth.errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: theme.colorScheme.error),
                              ),
                            ),
                    ),
                    Observer(
                      builder: (_) => PrimaryButton(
                        label: 'Entrar',
                        isLoading: _auth.isLoading,
                        onPressed: _submit,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                      child: const Text('Não tem conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
