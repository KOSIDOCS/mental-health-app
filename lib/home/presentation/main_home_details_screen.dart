import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/home/widget/custom_star.dart';
import 'package:mental_health_care_app/uis/custom_dividers.dart';

class MainHomeDetailsScreen extends StatefulWidget {
  const MainHomeDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeDetailsScreen> createState() => _MainHomeDetailsScreenState();
}

class _MainHomeDetailsScreenState extends State<MainHomeDetailsScreen> {
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
                          child: Icon(
                            Icons.chevron_left,
                            color: Theme.of(context).iconTheme.color,
                            size: 32.0,
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
                            'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
                            height: 110.0,
                            width: 110.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            'Drozdov Pavel',
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
                                  text: 'Gestalt',
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
                                      text: '4 years experience',
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
                              rating: 4.0,
                            ), // star rating widget
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '4.8',
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '(10)',
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
                          'I am a student of F.E. Vasilyuk. I consult in line with understanding therapy, combining classical psychology and Christian wisdom. The ministry of a psychologist can be called “life support”. I really want every person to love life and could choose life with all his heart!',
                    ),
                    CustomShortDividers(),
                    educationSection(
                      title: 'Education',
                      startYear: 1990,
                      endYear: 1994,
                      description:
                          'Moscow State Psychological and Pedagogical University, Faculty of Psychological Counseling, Department of Individual and Group Psychotherapy Vasilyuk F.E., qualification “Psychologist. Psychology teacher.',
                    ),
                    CustomShortDividers(),
                    placeOfWork(
                      title: 'Place of work',
                      workType: 'Self-employed',
                    ),
                    CustomShortDividers(),
                    diplomarAndCertSection(
                      title: 'Diplomas and certificates',
                      total: 11,
                    ),
                    CustomShortDividers(),
                    reviewSection(
                      title: 'Reviews',
                      total: 15,
                    ),
                    articlesSection(
                      title: 'Articles',
                      total: 4,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                height: 90.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
                child: Text('Heelo'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget reviewSection({required String title, required int total}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
      ),
      margin: EdgeInsets.only(top: 26.0, bottom: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                    ),
              ),
              SizedBox(width: 8.0),
              Text(
                '$total',
                style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                      color: AppColors.mentalBarUnselected,
                    ),
              ),
              const Spacer(),
              Text(
                'Show all',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.0,
                      color: AppColors.mentalBrandColor,
                    ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.mentalBrandColor,
                size: 32.0,
              ),
            ],
          ),
          SizedBox(height: 8.0),
          reviewsText(),
          reviewsText(),
          CustomShortDividers(),
        ],
      ),
    );
  }

  Widget articlesSection({required String title, required int total}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
      ),
      margin: EdgeInsets.only(top: 26.0, bottom: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                    ),
              ),
              SizedBox(width: 8.0),
              Text(
                '$total',
                style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                      color: AppColors.mentalBarUnselected,
                    ),
              ),
              const Spacer(),
              Text(
                'Show all',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.0,
                      color: AppColors.mentalBrandColor,
                    ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.mentalBrandColor,
                size: 32.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget reviewsText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anna',
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
                  rating: 4.0,
                ),
                SizedBox(width: 15.0),
                Text(
                  'February 3, 2022',
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
            'Thank you! You created a trusting atmosphere that allowed you to open up and live your feelings next to you.',
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

  Widget diplomarAndCertSection({required String title, required int total}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
      ),
      margin: EdgeInsets.only(top: 26.0, bottom: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                    ),
              ),
              SizedBox(width: 8.0),
              CircleAvatar(
                radius: 12.0,
                backgroundColor: AppColors.mentalRoundedIconColor,
                child: Text(
                  '$total',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.0,
                        color: AppColors.mentalBrandColor,
                      ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: AppColors.mentalBrandColor,
                size: 32.0,
              ),
            ],
          ),
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
