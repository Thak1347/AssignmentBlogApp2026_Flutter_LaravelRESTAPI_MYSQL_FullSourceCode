class AppConfig {
  static const String appName = 'Blog App';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberMeKey = 'remember_me';

  // Pagination
  static const int postsPerPage = 10;
  static const int commentsPerPage = 20;

  // Timeouts
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
}
