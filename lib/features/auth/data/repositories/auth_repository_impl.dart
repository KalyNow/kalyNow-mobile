import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) {
    return _remoteDataSource.register(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<void> logout() {
    return _remoteDataSource.logout();
  }

  @override
  Future<User?> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }
}
