import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/core/application/custom_navigation_controller.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';

class CustomBottomNavigation extends StatelessWidget {
  CustomBottomNavigation({Key? key}) : super(key: key);

  final CustomNavigationController customNavigationController =
      Get.put(CustomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.03,
            top: 10.0,
            right: MediaQuery.of(context).size.width * 0.03),
        child: Row(
          children: customNavigationController
              .getAllTabs()
              .map((icon) => CustomBottomBars(
                  iconImage: icon.icon,
                  title: icon.titel,
                  id: icon.id,
                  onPressed: () {
                    //Get.back();
                    customNavigationController.selectedTabIndex = icon.id;
                    Get.toNamed(icon.pageName);
                  },
                  currentTab: customNavigationController.selectedTabIndex))
              .toList(),
        ),
      ),
    );
  }
}
