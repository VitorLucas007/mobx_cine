import 'dart:convert';

import 'package:mobx_cine/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda usuários e sessão no próprio aparelho (SharedPreferences = pequeno "bloco de notas" chave → valor).
/// Não usa internet: faz o papel de um servidor de login de mentirinha.
class AuthLocalDataSource {
  AuthLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _usersKey = 'users'; // lista de todos os usuários cadastrados
  static const _sessionKey = 'session_email'; // e-mail de quem está logado

  /// Lê o texto salvo e transforma em lista. SharedPreferences só guarda texto simples,
  /// então a lista é salva como JSON e convertida de volta aqui.
  List<Map<String, dynamic>> _readUsers() {
    final raw = _prefs.getString(_usersKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  /// Procura um usuário pelo e-mail. Devolve null se não existir.
  Map<String, dynamic>? findByEmail(String email) {
    for (final user in _readUsers()) {
      if (user['email'] == email) return user;
    }
    return null;
  }

  /// Adiciona o usuário à lista, junto com o hash da senha (nunca a senha pura).
  Future<void> saveUser(UserModel user, String passwordHash) async {
    final users = _readUsers()..add({...user.toJson(), 'passwordHash': passwordHash});
    await _prefs.setString(_usersKey, jsonEncode(users));
  }

  // ───── Sessão: lembrar quem está logado ─────
  String? get sessionEmail => _prefs.getString(_sessionKey);

  Future<void> saveSession(String email) => _prefs.setString(_sessionKey, email);

  Future<void> clearSession() => _prefs.remove(_sessionKey);
}
