import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/articles/application/articles_controller.dart';
import 'package:mental_health_care_app/articles/widgets/article_section.dart';
import 'package:mental_health_care_app/core/custom_ui_state/custom_stateful_ui_state.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';
import 'package:mental_health_care_app/utils/focus_helper.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  _ArticlesScreenState createState() =>
      _ArticlesScreenState(Duration(milliseconds: 300));
}

class _ArticlesScreenState extends CustomStatefulUIState<ArticlesScreen> {
  _ArticlesScreenState(Duration animationDuration) : super(animationDuration);

  final ArticlesController _articlesController = Get.find();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  void initState() {
    super.initState();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollController.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context: context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: mainHeadingAnimation.value,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: CustomSpacing.kHorizontalPad,
                                ),
                                child: mainHeading(
                                  text: CustomText.kmentalArticleScreenHeader,
                                  context: context,
                                ),
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
                                  _articlesController.openAndCloseSearch();
                                  _articlesController.getDummyPsychologistsData();
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
                  Obx(
                    () {
                      return _articlesController.getIsSearchOpen
                          ? Padding(
                            padding: EdgeInsets.only(
                                left: CustomSpacing.kHorizontalPad,
                                top: CustomSpacing.kHorizontalPad,
                              ),
                            child: CustomSearchBar(
                                controller: _articlesController.searchController,
                                keyboardType: TextInputType.text,
                                placeholder: 'Search',
                                onChanged: (String? value) {
                                  print(value);
                                  //_articlesController.searchPsychologists();
                                },
                              ),
                          )
                          : Container();
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ArticlesSection(
                    articles: _articlesController.getAllArticles,
                    title: CustomText.kmentalArticleScreenHeader2,
                    scrollController: _scrollController,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  ArticlesSection(
                    articles: _articlesController.getAllArticles,
                    title: CustomText.kmentalArticleScreenHeader3,
                    scrollController: _scrollController2,
                  )
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
