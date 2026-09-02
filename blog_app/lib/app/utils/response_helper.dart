class ResponseHelper {
  static List<dynamic> extractList(dynamic response) {
    if (response is List) {
      return response;
    }

    if (response is Map<String, dynamic>) {
      // Try common keys
      final dataKeys = ['data', 'posts', 'results', 'items'];
      for (final key in dataKeys) {
        final value = response[key];
        if (value is List) {
          return value;
        }
      }
    }

    return [];
  }
}
