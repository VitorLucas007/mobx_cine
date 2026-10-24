import 'package:mobx_cine/features/auth/domain/entities/user.dart';
import 'package:mobx_cine/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<User?> call() => _repository.getCurrentUser();
}
