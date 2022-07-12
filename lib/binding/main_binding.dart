import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/admission/application/admission_controller.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/chats/application/chats_controller.dart';
import 'package:mental_health_care_app/consultations/application/consultation_controller.dart';
import 'package:mental_health_care_app/core/application/custom_navigation_controller.dart';
import 'package:mental_health_care_app/home/application/home_controller.dart';
import 'package:mental_health_care_app/makeappointment/application/make_appointment_controller.dart';
import 'package:mental_health_care_app/onboard/application/onboard_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() async {
    await initializeFirebase();
    Get.put<AuthController>(AuthController(), permanent: true);
    // Get.put<WelcomeController>(WelcomeController());
    Get.put<OnboardingController>(OnboardingController());
    Get.put<HomeController>(HomeController());
    Get.put<CustomNavigationController>(CustomNavigationController());
    Get.put<AdmissionController>(AdmissionController());
    Get.put<MakeAppointmentController>(MakeAppointmentController());
    Get.put<ConsultationController>(ConsultationController());
    Get.put<ChatsController>(ChatsController());
  }

  Future initializeFirebase() async {
    Get.lazyPut<FirebaseAuth>(()=>FirebaseAuth.instance, fenix: true);
    Get.lazyPut<FirebaseFirestore>(()=>FirebaseFirestore.instance, fenix: true);
    Get.lazyPut<FirebaseStorage>(()=>FirebaseStorage.instance, fenix: true);
  }
  
}