import 'package:mobx_cine/features/auth/domain/entities/user.dart';

/// CONTRATO da autenticação: o que o app pode pedir, sem saber onde os dados ficam.
/// Quem implementa é o AuthRepositoryImpl (camada data).
abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  /// Devolve o usuário da sessão salva, ou null se ninguém estiver logado.
  Future<User?> getCurrentUser();
  Future<void> logout();
}
