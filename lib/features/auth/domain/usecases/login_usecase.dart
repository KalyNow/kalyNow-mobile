import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  @override
  Future<User> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
