import 'package:get/get.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/routes/app_routes.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';

class CustomNavigationController extends GetxController {
  final _selectedTabIndex = 1.obs;
  set selectedTabIndex(value) => this._selectedTabIndex.value = value;
  get selectedTabIndex => this._selectedTabIndex.value;

  final List<BarIcon> _iconsList = [
    BarIcon(BottomBarImages.kBottomIcon1, BottomBarIconTitles.kBottomText1, 1, Routes.HOME),
    BarIcon(BottomBarImages.kBottomIcon2, BottomBarIconTitles.kBottomText2, 2, Routes.CHATS),
    BarIcon(BottomBarImages.kBottomIcon3, BottomBarIconTitles.kBottomText3, 3, Routes.CONSULTATIONS),
    BarIcon(BottomBarImages.kBottomIcon4, BottomBarIconTitles.kBottomText4, 4, Routes.ARTICLES),
    BarIcon(BottomBarImages.kBottomIcon5, BottomBarIconTitles.kBottomText5, 5, Routes.PROFILE),
  ];

  List<BarIcon> getAllTabs() {
    return _iconsList;
  }

  getTotalTabs() {
    return _iconsList.length;
  }

}