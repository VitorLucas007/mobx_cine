import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/core/utils/validators.dart';
import 'package:mobx_cine/features/auth/domain/entities/user.dart';
import 'package:mobx_cine/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String name,
    required String email,
    required String password,
  }) async {
    final error = Validators.name(name) ??
        Validators.email(email) ??
        Validators.password(password);
    if (error != null) throw AppException(error);

    return _repository.register(name: name, email: email, password: password);
  }
}
