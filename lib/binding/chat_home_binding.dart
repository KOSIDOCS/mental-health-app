import 'package:get/get.dart';
import 'package:mental_health_care_app/chats/application/chat_home_controller.dart';

class ChatHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatHomeController>(ChatHomeController());
  }
  
}