import 'package:blog_app/app/modules/comments/controllers/comments_controller.dart';
import 'package:get/get.dart';

class CommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommentController>(() => CommentController(), fenix: true);
  }
}
