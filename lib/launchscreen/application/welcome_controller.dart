import 'package:get/get.dart';
import 'package:mental_health_care_app/routes/app_routes.dart';

class WelcomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _departWelcome();
  }

  void _departWelcome() async {
    await Future.delayed(Duration(seconds: 3));
    Get.offAllNamed(Routes.ONBOARD);
  }
}