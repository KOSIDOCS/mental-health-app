import 'package:get/get.dart';
import 'package:mental_health_care_app/consultations/application/consultation_controller.dart';

class ConsultationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConsultationController>(ConsultationController());
  }
  
}