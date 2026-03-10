import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // TODO(dev): inject Dio and implement real API calls.

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Stub: replace with real API call.
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel(
      id: 'user-1',
      email: email,
      name: 'Demo User',
    );
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // Stub: replace with real API call.
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel(
      id: 'user-1',
      email: email,
      name: name,
    );
  }

  @override
  Future<void> logout() async {
    // Stub: replace with real API call.
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // Stub: replace with real API call.
    return null;
  }
}
