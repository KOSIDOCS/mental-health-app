import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/typography_theme.dart';

final ThemeData mentalHealthThemeDark = buildDarkTheme();

ThemeData buildDarkTheme() {
  TextStyle _builtTextStyle(Color color, {double size = 16.0}) {
    return TextStyle(color: color, fontSize: size);
  }

  UnderlineInputBorder _buildBorder(Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(8.0),
    );
  }
  
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(8),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: _buildBorder(AppColors.mentalOnboardTextColor),
      errorBorder: _buildBorder(Colors.red),
      focusedBorder: _buildBorder(AppColors.mentalBrandColor),
      disabledBorder: _buildBorder(AppColors.mentalOnboardTextColor),
      errorStyle: _builtTextStyle(Colors.red),
      labelStyle: _builtTextStyle(AppColors.mentalOnboardTextColor),
      helperStyle: _builtTextStyle(AppColors.mentalOnboardTextColor),
      hintStyle: _builtTextStyle(AppColors.mentalOnboardTextColor),
      prefixStyle: _builtTextStyle(AppColors.mentalOnboardTextColor),
    ),
    backgroundColor: AppColors.mentalDarkThemeColor,
    scaffoldBackgroundColor: AppColors.mentalDarkThemeColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.mentalDarkThemeColor,
      selectedItemColor: AppColors.mentalPureWhite,
      unselectedItemColor: AppColors.mentalBarUnselectedDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.mentalDarkThemeColor,
      iconTheme: IconThemeData(
        color: AppColors.mentalBrandLightColor,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: AppColors.mentalDarkThemeColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    iconTheme: IconThemeData(
      color: AppColors.mentalBrandLightColor,
    ),
    cardColor: AppColors.mentalDarkThemeColor,
    canvasColor: AppColors.mentalDarkThemeColor,
    brightness: Brightness.dark,
    primaryColor: AppColors.mentalBrandColor,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.mentalBrandColor,
      disabledColor: AppColors.mentalOnboardTextColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: AppColors.mentalBrandColor,
      ),
    ),
    dialogBackgroundColor: AppColors.mentalDarkThemeColor,
    textTheme: mentalHealthTextThemeDark(base.textTheme),
    primaryTextTheme: Typography().white,
    colorScheme: ColorScheme.dark(
      primary: AppColors.mentalBrandColor,
      surface: AppColors.mentalDarkThemeColor,
      background: AppColors.mentalDarkThemeColor,
      brightness: Brightness.dark,
    ),
  );
}

final ThemeData mentalHealthThemeLight = buildLightTheme();

ThemeData buildLightTheme() {
   TextStyle _builtTextStyle(Color color, {double size = 16.0}) {
    return TextStyle(color: color, fontSize: size);
  }

  UnderlineInputBorder _buildBorder(Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(8),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: _buildBorder(AppColors.mentalBorderColor),
      errorBorder: _buildBorder(Colors.red),
      focusedBorder: _buildBorder(AppColors.mentalBrandColor),
      disabledBorder: _buildBorder(AppColors.mentalOnboardTextColor),
      errorStyle: _builtTextStyle(Colors.red),
      labelStyle: _builtTextStyle(AppColors.mentalOnboardTextColor),
      helperStyle: _builtTextStyle(AppColors.mentalOnboardTextColor),
      hintStyle: _builtTextStyle(AppColors.mentalBorderColor),
      prefixStyle: _builtTextStyle(AppColors.mentalOnboardTextColor),
    ),
    backgroundColor: AppColors.mentalBrandLightColor,
    scaffoldBackgroundColor: AppColors.mentalBrandLightColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.mentalBrandLightColor,
      selectedItemColor: AppColors.mentalDarkColor,
      unselectedItemColor: AppColors.mentalBarUnselected,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.mentalBrandLightColor,
      iconTheme: IconThemeData(
        color: AppColors.mentalDarkColor,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.mentalBrandLightColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    iconTheme: IconThemeData(
      color: AppColors.mentalDarkColor,
    ),
    cardColor: AppColors.mentalBrandLightColor,
    canvasColor: AppColors.mentalBrandLightColor,
    brightness: Brightness.light,
    primaryColor: AppColors.mentalBrandColor,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.mentalBrandColor,
      disabledColor: AppColors.mentalOnboardTextColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: AppColors.mentalBrandColor,
      ),
    ),
    dialogBackgroundColor: AppColors.mentalBrandLightColor,
    textTheme: mentalHealthTextThemeLight(base.textTheme),
    primaryTextTheme: Typography().black,
    colorScheme: ColorScheme.light(
      primary: AppColors.mentalBrandColor,
      surface: AppColors.mentalBrandLightColor,
      background: AppColors.mentalBrandLightColor,
      brightness: Brightness.light,
    ),
  );
}