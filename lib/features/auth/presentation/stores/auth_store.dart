import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/features/auth/domain/entities/user.dart';
import 'package:mobx_cine/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mobx_cine/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobx_cine/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mobx_cine/features/auth/domain/usecases/register_usecase.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

/// STORE da autenticação: guarda quem está logado e executa login, cadastro e logout.
/// É singleton: a mesma instância é usada pelo app inteiro (splash, login, home).
class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  _AuthStoreBase(
    this._login,
    this._register,
    this._getCurrentUser,
    this._logout,
  );

  final LoginUseCase _login;
  final RegisterUseCase _register;
  final GetCurrentUserUseCase _getCurrentUser;
  final LogoutUseCase _logout;

  // ───────── Estado ─────────
  @observable
  User? user;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  // ───────── Derivado ─────────
  @computed
  bool get isLoggedIn => user != null;

  // ───────── Ações ─────────
  @action
  void clearError() => errorMessage = null;

  /// Chamado pela splash: se já existe sessão salva, preenche o `user`.
  @action
  Future<void> checkSession() async {
    user = await _getCurrentUser();
  }

  /// Retorna true se deu certo (a tela decide se navega).
  @action
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    try {
      user = await _login(email: email, password: password);
      return true;
    } on AppException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Erro inesperado. Tente novamente.';
      return false;
    } finally {
      isLoading = false; // roda sempre, com sucesso ou erro
    }
  }

  @action
  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    try {
      user = await _register(name: name, email: email, password: password);
      return true;
    } on AppException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Erro inesperado. Tente novamente.';
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    await _logout();
    user = null;
  }
}
