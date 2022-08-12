import 'package:get/get.dart';
import 'package:mental_health_care_app/admission/presentation/admission_screen.dart';
import 'package:mental_health_care_app/articles/presentation/articles_details_screen.dart';
import 'package:mental_health_care_app/articles/presentation/articles_screen.dart';
import 'package:mental_health_care_app/auth/presentation/auth_login_screen.dart';
import 'package:mental_health_care_app/auth/presentation/auth_password_recovery_screen.dart';
import 'package:mental_health_care_app/auth/presentation/auth_signup_screen.dart';
import 'package:mental_health_care_app/binding/articles_binding.dart';
import 'package:mental_health_care_app/binding/chat_home_binding.dart';
import 'package:mental_health_care_app/binding/chat_room_binding.dart';
import 'package:mental_health_care_app/binding/consultation_binding.dart';
import 'package:mental_health_care_app/binding/home_binding.dart';
import 'package:mental_health_care_app/binding/profile_binding.dart';
import 'package:mental_health_care_app/chats/presentation/chat_room_screen.dart';
import 'package:mental_health_care_app/chats/presentation/chats_screen.dart';
import 'package:mental_health_care_app/consultations/presentation/consultation_details_screen.dart';
import 'package:mental_health_care_app/consultations/presentation/consultations_screen.dart';
import 'package:mental_health_care_app/home/presentation/main_home_details_screen.dart';
import 'package:mental_health_care_app/home/presentation/main_home_page_screen.dart';
import 'package:mental_health_care_app/launchscreen/presentation/welcome_screen.dart';
import 'package:mental_health_care_app/makeappointment/presentation/make_appointment_screen.dart';
import 'package:mental_health_care_app/onboard/presentation/onboarding_screen.dart';
import 'package:mental_health_care_app/profile/presentation/edit_profile_screen.dart';
import 'package:mental_health_care_app/profile/presentation/profile_screen.dart';
import 'package:mental_health_care_app/routes/app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: INITIAL,
      page: () => WelcomeScreen(),
    ),
    GetPage(
      name: Routes.ONBOARD,
      page: () => OnboardingScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => AuthLoginScreen(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => AuthSignUpScreen(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => AuthPasswordRecoveryScreen(),
      fullscreenDialog: true,
      transition: Transition.native,
      popGesture: true,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => MainHomePageScreen(),
      bindings: [HomeBinding()],
      children: [
        GetPage(
          name: Routes.DETAILSPAGE,
          page: () => MainHomeDetailsScreen(),
        ),
      ],
    ),
    GetPage(
      name: Routes.CHATS,
      page: () => ChatsScreen(),
      bindings: [ChatHomeBinding()],
      children: [
        GetPage(
          name: Routes.CHATROOM,
          page: () => ChatRoomScreen(),
          bindings: [ChatRoomBinding()],
        ),
      ],
    ),
    GetPage(
        name: Routes.CONSULTATIONS,
        page: () => ConsultationScreen(),
        bindings: [ConsultationBinding()],
        children: [
          GetPage(
            name: Routes.CONSULTATION_DETAILS,
            page: () => ConsultationDetailsScreen(),
          ),
        ]),
    GetPage(
      name: Routes.ARTICLES,
      page: () => ArticlesScreen(),
      bindings: [ArticleBinding()],
      children: [
        GetPage(
          name: Routes.ARTICLE_DETAILS,
          page: () => ArticleDetailsScreen(),
        ),
      ],
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileScreen(),
      bindings: [ProfileMainBinding()],
      children: [
        GetPage(
          name: Routes.PROFILE_EDIT,
          page: () => EditProfileScreen(),
        ),
      ],
    ),
    GetPage(
      name: Routes.ADMISSIONPAGE,
      page: () => AdmissionScreen(),
    ),
    GetPage(
      name: Routes.MAKEAPPOINTMENT,
      page: () => MakeAppointmentScreen(),
    ),
  ];
}
