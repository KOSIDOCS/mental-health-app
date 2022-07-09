import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MakeAppointmentController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  final RxString selectedPaymentOption = ''.obs;

  void setSelectedPaymentOption({ required String option}) {
    selectedPaymentOption.value = option;
  }
}