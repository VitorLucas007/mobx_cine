// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThemeStore on _ThemeStoreBase, Store {
  Computed<ThemeMode>? _$themeModeComputed;

  @override
  ThemeMode get themeMode => (_$themeModeComputed ??= Computed<ThemeMode>(
    () => super.themeMode,
    name: '_ThemeStoreBase.themeMode',
  )).value;

  late final _$isDarkAtom = Atom(
    name: '_ThemeStoreBase.isDark',
    context: context,
  );

  @override
  bool get isDark {
    _$isDarkAtom.reportRead();
    return super.isDark;
  }

  @override
  set isDark(bool value) {
    _$isDarkAtom.reportWrite(value, super.isDark, () {
      super.isDark = value;
    });
  }

  late final _$_ThemeStoreBaseActionController = ActionController(
    name: '_ThemeStoreBase',
    context: context,
  );

  @override
  void toggle() {
    final _$actionInfo = _$_ThemeStoreBaseActionController.startAction(
      name: '_ThemeStoreBase.toggle',
    );
    try {
      return super.toggle();
    } finally {
      _$_ThemeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDark: ${isDark},
themeMode: ${themeMode}
    ''';
  }
}
