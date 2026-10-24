import 'package:mobx_cine/core/di/injection.dart';
import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/core/utils/validators.dart';
import 'package:mobx_cine/core/widgets/primary_button.dart';
import 'package:mobx_cine/core/widgets/responsive_body.dart';
import 'package:mobx_cine/features/auth/presentation/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = getIt<AuthStore>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _auth.clearError());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _auth.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      // Remove login e cadastro da pilha: o usuário já entrou
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 420,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 16),
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
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmController,
                    obscureText: true,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      labelText: 'Confirmar senha',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) =>
                        value != _passwordController.text ? 'As senhas não conferem' : null,
                  ),
                  const SizedBox(height: 16),
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
                      label: 'Cadastrar',
                      isLoading: _auth.isLoading,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
