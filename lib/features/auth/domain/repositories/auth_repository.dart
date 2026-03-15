import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<void> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
}
