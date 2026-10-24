// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MoviesStore on _MoviesStoreBase, Store {
  Computed<List<Movie>>? _$filteredMoviesComputed;

  @override
  List<Movie> get filteredMovies =>
      (_$filteredMoviesComputed ??= Computed<List<Movie>>(
        () => super.filteredMovies,
        name: '_MoviesStoreBase.filteredMovies',
      )).value;

  late final _$stateAtom = Atom(
    name: '_MoviesStoreBase.state',
    context: context,
  );

  @override
  ViewState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ViewState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_MoviesStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$queryAtom = Atom(
    name: '_MoviesStoreBase.query',
    context: context,
  );

  @override
  String get query {
    _$queryAtom.reportRead();
    return super.query;
  }

  @override
  set query(String value) {
    _$queryAtom.reportWrite(value, super.query, () {
      super.query = value;
    });
  }

  late final _$loadMoviesAsyncAction = AsyncAction(
    '_MoviesStoreBase.loadMovies',
    context: context,
  );

  @override
  Future<void> loadMovies() {
    return _$loadMoviesAsyncAction.run(() => super.loadMovies());
  }

  late final _$_MoviesStoreBaseActionController = ActionController(
    name: '_MoviesStoreBase',
    context: context,
  );

  @override
  void setQuery(String value) {
    final _$actionInfo = _$_MoviesStoreBaseActionController.startAction(
      name: '_MoviesStoreBase.setQuery',
    );
    try {
      return super.setQuery(value);
    } finally {
      _$_MoviesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
errorMessage: ${errorMessage},
query: ${query},
filteredMovies: ${filteredMovies}
    ''';
  }
}
