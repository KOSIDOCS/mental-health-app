import 'package:get/get.dart';
import 'package:mental_health_care_app/home/application/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
  
}