import 'dart:convert';

import 'package:mobx_cine/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _usersKey = 'users';
  static const _sessionKey = 'session_email';

  List<Map<String, dynamic>> _readUsers() {
    final raw = _prefs.getString(_usersKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Map<String, dynamic>? findByEmail(String email) {
    for (final user in _readUsers()) {
      if (user['email'] == email) return user;
    }
    return null;
  }

  Future<void> saveUser(UserModel user, String passwordHash) async {
    final users = _readUsers()..add({...user.toJson(), 'passwordHash': passwordHash});
    await _prefs.setString(_usersKey, jsonEncode(users));
  }

  String? get sessionEmail => _prefs.getString(_sessionKey);

  Future<void> saveSession(String email) => _prefs.setString(_sessionKey, email);

  Future<void> clearSession() => _prefs.remove(_sessionKey);
}
