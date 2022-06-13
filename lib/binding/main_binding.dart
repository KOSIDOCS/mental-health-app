import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/onboard/application/onboard_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() async {
    await initializeFirebase();
    Get.put<AuthController>(AuthController(), permanent: true);
    // Get.put<WelcomeController>(WelcomeController());
    Get.put<OnboardingController>(OnboardingController());
  }

  Future initializeFirebase() async {
    Get.lazyPut<FirebaseAuth>(()=>FirebaseAuth.instance, fenix: true);
    Get.lazyPut<FirebaseFirestore>(()=>FirebaseFirestore.instance, fenix: true);
  }
  
}