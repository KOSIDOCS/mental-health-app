import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/auth/domain/user_model.dart';

class ProfileMainController extends GetxController {
  TextEditingController nameEditController = TextEditingController();
  TextEditingController emailEditController = TextEditingController();
  TextEditingController phoneEditController = TextEditingController();
  final AuthController _authController = Get.find();
  UserModel? get getUser => _authController.firestoreUser.value;

  @override
  void dispose() {
    nameEditController.dispose();
    emailEditController.dispose();
    phoneEditController.dispose();
    super.dispose();
  }
}