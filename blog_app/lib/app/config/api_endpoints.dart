class ApiEndpoints {
  // Base server domain without '/api'
  static const String domain = 'http://10.0.2.2:8000';

  // API base URL
  static const String baseUrl = '$domain/api';

  // Auth
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String currentUser = '/current-user';

  // Posts
  static const String posts = '/posts';
  static String postDetail(int id) => '/posts/$id';
  static String postComments(int postId) => '/posts/$postId/comments';

  // Comments
  static String deleteComment(int id) => '/comments/$id';

  // Images (points directly to domain storage, e.g., http://10.0.2.2:8000/storage/...)
  static String getImage(String path) => '$domain/storage/$path';
}
