import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/core/utils/validators.dart';
import 'package:mobx_cine/features/auth/domain/entities/user.dart';
import 'package:mobx_cine/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  // O método "call" permite usar o objeto como função: loginUseCase(email: ..., password: ...)
  Future<User> call({required String email, required String password}) async {
    final error = Validators.email(email) ?? Validators.password(password);
    if (error != null) throw AppException(error);

    return _repository.login(email: email, password: password);
  }
}
