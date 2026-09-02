import 'package:blog_app/app/modules/comments/bindings/comments_binding.dart';
import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/posts/bindings/posts_binding.dart';
import '../modules/posts/views/create_post_view.dart';
import '../modules/posts/views/post_details_view.dart';
import '../modules/posts/views/post_edit_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/comments/views/comments_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.postDetails,
      page: () => const PostDetailsView(),
      binding: PostBinding(),
    ),
    GetPage(
      name: AppRoutes.createPost,
      page: () => const CreatePostView(),
      binding: PostBinding(),
    ),
    GetPage(
      name: AppRoutes.editPost,
      page: () => const PostEditView(),
      binding: PostBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.comments,
      page: () => const CommentsView(),
      binding: CommentBinding(),
    ),
  ];
}
