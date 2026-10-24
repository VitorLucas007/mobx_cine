import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStoreBase with _$ThemeStore;

abstract class _ThemeStoreBase with Store {
  _ThemeStoreBase(this._prefs) {
    // Ao criar a store, lê a escolha salva (se existir)
    isDark = _prefs.getBool(_key) ?? false;
  }

  static const _key = 'is_dark_mode';
  final SharedPreferences _prefs;

  @observable
  bool isDark = false;

  /// Derivado: converte o bool no tipo que o MaterialApp entende.
  @computed
  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  @action
  void toggle() {
    isDark = !isDark;
    _prefs.setBool(_key, isDark); // salva sem precisar esperar
  }
}
