abstract final class AppConstants {
  // App info
  static const String appName = 'KalyNow';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.kalynow.com/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;

  // Shared preferences keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
}
