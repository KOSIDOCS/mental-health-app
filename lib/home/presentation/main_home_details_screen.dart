import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/articles/model/article_model.dart';
import 'package:mental_health_care_app/articles/widgets/article_card.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/home/application/home_controller.dart';
import 'package:mental_health_care_app/home/widget/custom_expand_items.dart';
import 'package:mental_health_care_app/home/widget/custom_star.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_dividers.dart';

class MainHomeDetailsScreen extends StatefulWidget {
  const MainHomeDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeDetailsScreen> createState() => _MainHomeDetailsScreenState();
}

class _MainHomeDetailsScreenState extends State<MainHomeDetailsScreen> {
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.chevron_left,
                              color: Theme.of(context).iconTheme.color,
                              size: 32.0,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, right: 17.0),
                          child: Icon(
                            Icons.bookmark_outline_rounded,
                            color: Theme.of(context).iconTheme.color,
                            size: 32.0,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 22.0),
                          child: Image.network(
                            homeController
                                .selectedPsychologist.value!.userImage,
                            height: 110.0,
                            width: 110.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            homeController.selectedPsychologist.value!.name,
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Transform.translate(
                            offset: Offset(2, -9),
                            child: RichText(
                              text: TextSpan(
                                  text: homeController.selectedPsychologist
                                      .value!.specialization,
                                  style: Theme.of(context).textTheme.caption,
                                  children: [
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: Offset(2, 1),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: Text(
                                            '.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                  fontSize: 23.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${homeController.selectedPsychologist.value!.experience} years experience',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomStarsRating(
                              totalStars: 5,
                              rating: homeController
                                  .selectedPsychologist.value!.star,
                            ), // star rating widget
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              homeController.selectedPsychologist.value!.star
                                  .toString(),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '( ' + homeController.selectedPsychologist.value!.reviews.length
                                  .toString() + ' )',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 36.5),
                    CustomShortDividers(),
                    aboutSection(
                      title: 'About the specialist',
                      description:
                          homeController.selectedPsychologist.value!.about,
                    ),
                    CustomShortDividers(),
                    educationSection(
                      title: 'Education',
                      startYear: homeController
                          .selectedPsychologist.value!.education['year_start'],
                      endYear: homeController
                          .selectedPsychologist.value!.education['year_end'],
                      description: homeController
                          .selectedPsychologist.value!.education['details'],
                    ),
                    CustomShortDividers(),
                    placeOfWork(
                      title: 'Place of work',
                      workType: homeController
                          .selectedPsychologist.value!.placeOfWork,
                    ),
                    CustomShortDividers(),
                    CustomExpandItems(
                      title: 'Diplomas and certificates',
                      total: homeController.selectedPsychologist.value!
                          .diplomarAndCertificate.length,
                      child: Container(),
                    ),
                    CustomShortDividers(),
                    CustomExpandItems(
                      title: 'Reviews',
                      total: homeController
                          .selectedPsychologist.value!.reviews.length,
                      child: reviewSection(),
                    ),
                    CustomShortDividers(),
                    CustomExpandItems(
                      title: 'Articles',
                      total: homeController
                          .selectedPsychologist.value!.articles.length,
                      child: articlesSection(),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.76,
              left: MediaQuery.of(context).size.width * 0.03,
              child: CustomBtn(
                onPressed: () {
                  Get.toNamed('/admissionpage');
                },
                buttonText: CustomText.mentalAdmissionBtn,
                padding: EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 20.0, bottom: 20.0),
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.743,
              left: MediaQuery.of(context).size.width * 0.75,
              child: CustomCirclerBtn(
                bagroundRadius: 35.0,
                imgName: BrandImages.kIconChat,
                onPressed: () => {
                  homeController.setOpenChatWith()
                },
                redus: 33.9,
                imgHeight: 35.0,
                imgWidth: 35.0,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }

  Widget reviewSection() {
    return Column(
      children: [
        SizedBox(height: 8.0),
        ...homeController.selectedPsychologist.value!.reviews.map((review) {
          return reviewsText(review: review);
        }).toList(),
      ],
    );
  }

  Widget articlesSection() {
    return Container(
      height: 240.0,
      margin: EdgeInsets.only(top: 15.0),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: homeController.selectedPsychologist.value!.articles.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ArticleCard(article: ArticleModel.fromMap(homeController
              .selectedPsychologist.value!.articles[index], uid: homeController
              .selectedPsychologist.value!.articles[index].id ?? "",));
        },
      ),
    );
  }

  Widget reviewsText({required dynamic review}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review['name'],
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Row(
              children: [
                CustomStarsRating(
                  totalStars: 5,
                  rating: double.parse(review['star']),
                ),
                SizedBox(width: 15.0),
                Text(
                  review['date'],
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0,
                        color: AppColors.mentalBarUnselected,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7.0),
          Text(
            review['said'],
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                ),
          ),
          const SizedBox(height: 14.0),
        ],
      ),
    );
  }

  Widget aboutSection({required String title, required String description}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
      ),
      margin: EdgeInsets.only(top: 26.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              description,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget educationSection(
      {required String title,
      required int startYear,
      required int endYear,
      required String description}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
      ),
      margin: EdgeInsets.only(top: 24.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              '$startYear-$endYear',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              description,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget placeOfWork({required String title, required String workType}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
      ),
      margin: EdgeInsets.only(top: 24.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              workType,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
