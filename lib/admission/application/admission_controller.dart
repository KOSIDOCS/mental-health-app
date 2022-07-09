import 'package:get/state_manager.dart';

class AdmissionController extends GetxController {

  final RxString selectedTime = ''.obs;

  void setSelectedTime({ required String time}) {
    selectedTime.value = time;
  }
}