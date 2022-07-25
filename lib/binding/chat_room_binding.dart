import 'package:get/get.dart';
import 'package:mental_health_care_app/chats/application/chats_controller.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatsController>(ChatsController());
  }
  
}