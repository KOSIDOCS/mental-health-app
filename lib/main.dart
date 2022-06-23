import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mental_health_care_app/binding/main_binding.dart';
import 'package:mental_health_care_app/core/theme/mental_heath_theme.dart';
import 'package:mental_health_care_app/firebase_options.dart';
import 'package:mental_health_care_app/launchscreen/presentation/welcome_screen.dart';
import 'package:mental_health_care_app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.ﬁ
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return GetMaterialApp(
      initialBinding: MainBinding(),
      title: 'Flutter Demo',
      theme: mentalHealthThemeLight,
      // theme: mentalHealthThemeDark,
      darkTheme: mentalHealthThemeDark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      home: const WelcomeScreen(),
    );
  }
}
