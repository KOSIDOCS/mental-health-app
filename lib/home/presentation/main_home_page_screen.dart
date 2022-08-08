import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/core/application/presence_system_controller.dart';
import 'package:mental_health_care_app/core/custom_ui_state/custom_stateful_ui_state.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/home/application/home_controller.dart';
import 'package:mental_health_care_app/home/model/psychologist_model.dart';
import 'package:mental_health_care_app/home/widget/custom_user_card.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/uis/custom_modals.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

class MainHomePageScreen extends StatefulWidget {
  const MainHomePageScreen({Key? key}) : super(key: key);

  @override
  _MainHomePageScreenState createState() =>
      _MainHomePageScreenState(Duration(seconds: 2));
}

class _MainHomePageScreenState extends CustomStatefulUIState<MainHomePageScreen>
    with WidgetsBindingObserver {
  _MainHomePageScreenState(Duration animationDuration)
      : super(animationDuration);

  AuthController _authController = Get.put(AuthController());

  PresenceSystemController _presenceSystemController = Get.find();

  HomeController homeController = Get.put(HomeController());

  bool changeImageColor = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _presenceSystemController
        .configureUserPresence(_authController.firebaseUser.value!.uid);
    animationController.forward();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _presenceSystemController.connect();
    }
    if (state == AppLifecycleState.resumed) {
      _presenceSystemController.disconnect();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              left: CustomSpacing.kHorizontalPad,
            ),
            height: MediaQuery.of(context).size.height,
            child: DefaultTabController(
              length: 6,
              child: Column(
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     _authController.userSignOut();
                  //   },
                  //   child: Text('Log out'),
                  // ),
                  customSizedBox(context: context, size: 0.04),
                  Row(
                    children: [
                      AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: mainHeadingAnimation.value,
                              child: mainHeading(
                                text: CustomText.mentalHomeTitle,
                                context: context,
                              ),
                            );
                          }),
                      Spacer(),
                      AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return Container(
                              padding: EdgeInsets.only(
                                right: CustomSpacing.kHorizontalPad,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // homeController.uploadDummy();
                                  homeController.openAndCloseSearch();
                                },
                                child: ImageIcon(
                                  AssetImage(
                                      'assets/images/${BrandImages.kSearchIcon}'),
                                  color: Theme.of(context).iconTheme.color,
                                  size: searchIconAnimation.value * 30.0,
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                  customSizedBox(context: context, size: 0.03),
                  AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(buttontabsAnimation.value * 6, 0.0),
                          child: ButtonsTabBar(
                            controller: homeController.tabController,
                            radius: 30.0,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
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
                                icon: GestureDetector(
                                  onDoubleTap: () {
                                    showSearchBottomSheet(
                                        context: context,
                                        list: homeController.bottomSearch,
                                        controller: homeController,
                                        onPressed: () {});
                                  },
                                  child: Image.asset(
                                    'assets/images/${BrandImages.kIconUnion}',
                                    color: changeImageColor
                                        ? AppColors.mentalBrandLightColor
                                        : AppColors.mentalBrandColor,
                                    width: 25.0,
                                    height: 25.0,
                                  ),
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
                        );
                      }),
                  customSizedBox(context: context, size: 0.03),
                  Obx(
                    () {
                      return homeController.searchIsOpen
                          ? CustomSearchBar(
                              controller: homeController.searchController,
                              keyboardType: TextInputType.text,
                              placeholder: 'Search',
                              onChanged: (String? value) {
                                print(value);
                                homeController.searchPsychologists();
                              },
                            )
                          : Container();
                    },
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: bodyAnimation.value,
                          child: TabBarView(
                            controller: homeController.tabController,
                            children: [
                              ShowFilterList(
                                list: homeController.psychologistsList,
                              ),
                              ShowFilterList(
                                list: homeController.gestaltList,
                              ),
                              ShowFilterList(
                                list: homeController.artTherapyList,
                              ),
                              ShowFilterList(
                                list: homeController.coachingList,
                              ),
                              ShowFilterList(
                                list: homeController.familyList,
                              ),
                              ShowFilterList(
                                list: homeController.careerList,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigation(),
      ),
    );
  }
}

class ShowFilterList extends StatelessWidget {
  final List<PsychologistModel> list;
  ShowFilterList({Key? key, required this.list}) : super(key: key);

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return list.isEmpty
                ? Center(child: CircularProgressIndicator())
                : CustomUserCard(
                    experience: list[index].experience,
                    userImg: list[index].userImage,
                    name: list[index].name,
                    specialization: list[index].specialization,
                    minAmount: list[index].minAmount,
                    star: list[index].star,
                    onPressed: () {
                      homeController.setSelectedPsychologist(index);
                    },
                  );
          },
        );
      },
    );
  }
}
