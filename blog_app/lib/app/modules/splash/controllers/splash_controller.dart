import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // 1. Force a 2-second delay for the splash screen
    await Future.delayed(const Duration(seconds: 2));

    // 2. Navigate off splash screen without letting user return to it
    Get.offAllNamed(AppRoutes.home); // or AppRoutes.login / AppRoutes.main
  }
}
