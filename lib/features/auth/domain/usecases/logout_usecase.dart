import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCaseNoParams<void> {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  @override
  Future<void> call() {
    return _repository.logout();
  }
}
