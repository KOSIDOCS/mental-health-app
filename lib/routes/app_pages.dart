import 'package:get/get.dart';
import 'package:mental_health_care_app/articles/presentation/articles_screen.dart';
import 'package:mental_health_care_app/auth/presentation/auth_login_screen.dart';
import 'package:mental_health_care_app/auth/presentation/auth_password_recovery_screen.dart';
import 'package:mental_health_care_app/auth/presentation/auth_signup_screen.dart';
import 'package:mental_health_care_app/chats/presentation/chats_screen.dart';
import 'package:mental_health_care_app/consultations/presentation/consultations_screen.dart';
import 'package:mental_health_care_app/home/presentation/main_home_details_screen.dart';
import 'package:mental_health_care_app/home/presentation/main_home_page_screen.dart';
import 'package:mental_health_care_app/launchscreen/presentation/welcome_screen.dart';
import 'package:mental_health_care_app/onboard/presentation/onboarding_screen.dart';
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
      children: [
        GetPage(
          name: Routes.DETAILSPAGE,
          page: () => MainHomeDetailsScreen(),
        ),
      ]
    ),
    GetPage(
      name: Routes.CHATS,
      page: () => ChatsScreen(),
    ),
     GetPage(
      name: Routes.CONSULTATIONS,
      page: () => ConsultationScreen(),
    ),
     GetPage(
      name: Routes.ARTICLES,
      page: () => ArticlesScreen(),
    ),
     GetPage(
      name: Routes.PROFILE,
      page: () => ProfileScreen(),
    )
  ];
}
