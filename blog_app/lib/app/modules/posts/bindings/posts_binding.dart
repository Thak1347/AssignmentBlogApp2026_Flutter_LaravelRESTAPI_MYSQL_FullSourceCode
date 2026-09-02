
import 'package:blog_app/app/modules/posts/controllers/posts_controller.dart';
import 'package:get/get.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostsController>(() => PostsController(), fenix: true);
  }
}
