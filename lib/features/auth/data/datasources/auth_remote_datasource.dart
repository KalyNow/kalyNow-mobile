import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<void> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  // ── Login ────────────────────────────────────────────────────────────────
  // POST /auth/login → { accessToken, refreshToken }
  // Puis GET /auth/me → user
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokenRes = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final tokenData = tokenRes.data as Map<String, dynamic>;
      final accessToken = tokenData['accessToken'] as String;
      final refreshToken = tokenData['refreshToken'] as String;

      // Persister les tokens
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.authTokenKey, accessToken);
      await prefs.setString(AppConstants.refreshTokenKey, refreshToken);

      // Injecter le token dans Dio pour les prochains appels
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';

      // Récupérer le profil utilisateur
      final userRes = await _dio.get('/auth/me');
      return UserModel.fromJson(userRes.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error as AppException? ??
          AppException(
            e.response?.data?['message'] as String? ?? 'Identifiants invalides',
            statusCode: e.response?.statusCode,
          );
    }
  }

  // ── Register ─────────────────────────────────────────────────────────────
  // POST /auth/register → { message, email }
  // L'utilisateur doit vérifier son email avant de se connecter
  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _dio.post(
        '/auth/register',
        data: {'email': email, 'password': password, 'name': name},
      );
    } on DioException catch (e) {
      throw e.error as AppException? ??
          AppException(
            e.response?.data?['message'] as String? ?? 'Inscription échouée',
            statusCode: e.response?.statusCode,
          );
    }
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  // POST /auth/logout body: { refreshToken }
  @override
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConstants.refreshTokenKey);
      if (refreshToken != null) {
        await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
      }
    } on DioException {
      // Ignorer les erreurs réseau lors du logout
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.authTokenKey);
      await prefs.remove(AppConstants.refreshTokenKey);
      _dio.options.headers.remove('Authorization');
    }
  }

  // ── Get current user ─────────────────────────────────────────────────────
  // GET /auth/me (avec Authorization header)
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Restaurer le token depuis SharedPreferences si absent dans Dio
      if (_dio.options.headers['Authorization'] == null) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(AppConstants.authTokenKey);
        if (token == null) return null;
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      return null;
    }
  }
}
