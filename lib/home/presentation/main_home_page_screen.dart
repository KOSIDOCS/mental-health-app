import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

class MainHomePageScreen extends StatefulWidget {
  const MainHomePageScreen({Key? key}) : super(key: key);

  @override
  State<MainHomePageScreen> createState() => _MainHomePageScreenState();
}

class _MainHomePageScreenState extends State<MainHomePageScreen>
    with TickerProviderStateMixin {
  AuthController _authController = Get.put(AuthController());
  late TabController _tabController;

  bool changeImageColor = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: CustomSpacing.kHorizontalPad,
          ),
          height: MediaQuery.of(context).size.height,
          child: DefaultTabController(
            length: 6,
            child: Column(
              children: [
                customSizedBox(context: context, size: 0.04),
                Row(
                  children: [
                    mainHeading(
                      text: CustomText.mentalHomeTitle,
                      context: context,
                    ),
                    Spacer(),
                    ImageIcon(
                      AssetImage('assets/images/${BrandImages.kSearchIcon}'),
                      color: Theme.of(context).iconTheme.color,
                      size: 30.0,
                    ),
                  ],
                ),
                ButtonsTabBar(
                  controller: _tabController,
                  radius: 30.0,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  borderWidth: 1.0,
                  borderColor: AppColors.mentalBrandColor,
                  unselectedBackgroundColor:
                      Theme.of(context).scaffoldBackgroundColor,
                  backgroundColor: AppColors.mentalBrandColor,
                  unselectedBorderColor: AppColors.mentalBrandColor,
                  unselectedLabelStyle:
                      TextStyle(color: AppColors.mentalBrandColor),
                  labelStyle: TextStyle(color: Colors.white),
                  height: 56,
                  tabs: [
                    Tab(
                      // icon: Icon(Icons.graphic_eq_rounded),
                      icon: Image.asset(
                        'assets/images/${BrandImages.kIconUnion}',
                        color: changeImageColor
                            ? AppColors.mentalBrandLightColor
                            : AppColors.mentalBrandColor,
                        width: 25.0,
                        height: 25.0,
                      ),
                    ),
                    Tab(
                      text: CustomText.mentalHomeTab1Text,
                    ),
                    Tab(
                      text: CustomText.mentalHomeTab2Text,
                    ),
                    Tab(
                      text: CustomText.mentalHomeTab3Text,
                    ),
                    Tab(
                      text: CustomText.mentalHomeTab4Text,
                    ),
                    Tab(
                      text: CustomText.mentalHomeTab5Text,
                    ),
                  ],
                  onTap: (int currentTab) {
                    if (currentTab == 0) {
                      setState(() {
                        changeImageColor = true;
                      });
                    } else {
                      setState(() {
                        changeImageColor = false;
                      });
                    }
                    print(currentTab);
                  },
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                     // ListView.builder(itemBuilder: itemBuilder),
                      // Container(
                      //   color: Colors.transparent,
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/${ImagesPlaceHolders.kPsyPlaceholder1}',
                      //         width: 96.0,
                      //         height: 96.0,
                      //       ),
                      //       Column(
                      //         children: [
                      //           Text(
                      //             'Psychedelic',
                      //             style: TextStyle(
                      //               fontSize: 24.0,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //            Text(
                      //             'Psychedelic',
                      //             style: TextStyle(
                      //               fontSize: 24.0,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         ],
                      //       ), //  replace with Image from network
                      //     ],
                      //   ),
                      // ),
                      Center(
                        child: Text('Tab 2'),
                      ),
                      Center(
                        child: Text('Tab 3'),
                      ),
                      Center(
                        child: Text('Tab 4'),
                      ),
                      Center(
                        child: Text('Tab 5'),
                      ),
                      Center(
                        child: Text('Tab 6'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
      ),
    );
  }
}
