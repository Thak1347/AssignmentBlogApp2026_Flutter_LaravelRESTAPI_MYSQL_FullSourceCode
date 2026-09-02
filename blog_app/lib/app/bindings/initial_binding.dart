import 'package:get/get.dart';

import '../data/providers/auth_provider.dart';
import '../data/providers/comment_provider.dart';
import '../data/providers/post_provider.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/theme/controllers/theme_controller.dart';
import '../services/notification_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<NotificationService>(NotificationService(), permanent: true);

    // Providers
    Get.put<AuthProvider>(AuthProvider(), permanent: true);
    Get.put<PostProvider>(PostProvider(), permanent: true);
    Get.put<CommentProvider>(CommentProvider(), permanent: true);

    // Controllers
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
  }
}
