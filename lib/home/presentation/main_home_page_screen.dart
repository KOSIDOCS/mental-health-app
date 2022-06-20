import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
              TabBar(
                isScrollable: true,
                indicatorColor: Colors.transparent,
                enableFeedback: false,
                // overlayColor: ,
                tabs: [
                  Tab(
                    icon: ImageIcon(
                      AssetImage(
                          'assets/images/${BrandImages.kSearchIcon}'),
                      color: Theme.of(context).iconTheme.color,
                      size: 120.0,
                    ),
                  ),
                  Tab(
                    icon: ImageIcon(
                      AssetImage(
                          'assets/images/${BrandImages.kSearchIcon}'),
                      color: Theme.of(context).iconTheme.color,
                      size: 120.0,
                    ),
                  ),
                  Tab(
                    icon: ImageIcon(
                      AssetImage(
                          'assets/images/${BrandImages.kSearchIcon}'),
                      color: Theme.of(context).iconTheme.color,
                      size: 120.0,
                    ),
                  ),
                  Tab(
                    icon: ImageIcon(
                      AssetImage(
                          'assets/images/${BrandImages.kSearchIcon}'),
                      color: Theme.of(context).iconTheme.color,
                      size: 120.0,
                    ),
                  ),
                ],
                controller: _tabController,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(
                      child: Text('Tab 1'),
                    ),
                    Center(
                      child: Text('Tab 2'),
                    ),
                    Center(
                      child: Text('Tab 3'),
                    ),
                    Center(
                      child: Text('Tab 4'),
                    ),
                  ],
                ),
              ),
            ],
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
