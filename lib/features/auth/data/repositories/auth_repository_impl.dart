import 'dart:convert';

import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:mobx_cine/features/auth/data/models/user_model.dart';
import 'package:mobx_cine/features/auth/domain/entities/user.dart';
import 'package:mobx_cine/features/auth/domain/repositories/auth_repository.dart';
import 'package:crypto/crypto.dart';

/// Implementa o login/cadastro usando só o armazenamento local (sem servidor).
/// O Future.delayed simula o tempo de resposta de uma rede, para a tela mostrar o "carregando".
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._local);

  final AuthLocalDataSource _local;

  // Nunca guarde senha pura: guardamos só o "hash" (impressão digital da senha).
  String _hash(String password) => sha256.convert(utf8.encode(password)).toString();

  // "  Ana@Mail.com " e "ana@mail.com" passam a ser o mesmo e-mail
  String _normalize(String email) => email.trim().toLowerCase();

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simula a rede
    final normalized = _normalize(email);

    if (_local.findByEmail(normalized) != null) {
      throw const AppException('Este e-mail já está cadastrado.');
    }

    final user = UserModel(
      // O id é o momento do cadastro em milissegundos (simples e quase único)
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: normalized,
    );
    await _local.saveUser(user, _hash(password));
    await _local.saveSession(normalized); // já entra logado depois de cadastrar
    return user;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final normalized = _normalize(email);
    final data = _local.findByEmail(normalized);

    // Compara o hash da senha digitada com o hash salvo. Uma só mensagem para os dois casos
    // (e-mail inexistente ou senha errada), para não revelar quais e-mails existem.
    if (data == null || data['passwordHash'] != _hash(password)) {
      throw const AppException('E-mail ou senha incorretos.');
    }

    await _local.saveSession(normalized);
    return UserModel.fromJson(data);
  }

  @override
  Future<User?> getCurrentUser() async {
    final email = _local.sessionEmail;
    if (email == null) return null;

    final data = _local.findByEmail(email);
    return data == null ? null : UserModel.fromJson(data);
  }

  @override
  Future<void> logout() => _local.clearSession();
}
