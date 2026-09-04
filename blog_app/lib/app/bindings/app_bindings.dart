import 'package:blog_app/app/modules/comments/controllers/comments_controller.dart';
import 'package:get/get.dart';

import '../data/providers/auth_provider.dart';
import '../data/providers/comment_provider.dart';
import '../data/providers/post_provider.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/posts/controllers/posts_controller.dart';
import '../modules/profile/controllers/profile_controller.dart';
import '../modules/theme/controllers/theme_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Services (Singleton - Permanent)

    // Storage Service - For local data persistence
    Get.put<StorageService>(StorageService(), permanent: true);

    // API Service - For network requests
    Get.put<ApiService>(ApiService(), permanent: true);

    // Notification Service - Already initialized in main.dart
    // Get.find<NotificationService>() is available

    // Theme Controller - For dark/light mode
    Get.put<ThemeController>(ThemeController(), permanent: true);

    /// Provider (Singleton - Permanent)

    // Auth Provider - For authentication API calls
    Get.put<AuthProvider>(AuthProvider(), permanent: true);

    // Post Provider - For post API calls
    Get.put<PostProvider>(PostProvider(), permanent: true);

    // Comment Provider - For comment API calls
    Get.put<CommentProvider>(CommentProvider(), permanent: true);

    // Controller (Lazy Loading)

    // Auth Controller - Authentication logic
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);

    // Home Controller - Home screen logic
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    // Posts Controller - Post management logic
    Get.lazyPut<PostsController>(() => PostsController(), fenix: true);

    // Comment Controller - Comment management logic
    Get.lazyPut<CommentController>(() => CommentController(), fenix: true);

    // Profile Controller - Profile screen logic
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
