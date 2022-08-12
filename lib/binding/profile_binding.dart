import 'package:get/get.dart';
import 'package:mental_health_care_app/profile/application/profile_main_controller.dart';

class ProfileMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileMainController>(ProfileMainController());
  }
}