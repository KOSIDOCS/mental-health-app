import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardTemplate extends StatelessWidget {
  final PageController pageController;
  final String image;
  final String subTitle1;
  final String subTitle2;
  final String buttonText;
  final VoidCallback onPressed;
  final VoidCallback skipBtnPressed;
  const OnboardTemplate(
      {Key? key,
      required this.pageController,
      required this.image,
      required this.buttonText,
      required this.subTitle1,
      required this.subTitle2,
      required this.onPressed, required this.skipBtnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: skipBtnPressed,
                child: Text(
                  CustomText.skipText,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headline3,
                ),
              )
            ],
          ),
          SizedBox(height: 26.0),
          Container(
            height: 450.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          SizedBox(
            height: 18.0,
          ),
          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: WormEffect(
              dotWidth: 10.0,
              dotHeight: 10.0,
              activeDotColor: AppColors.mentalBrandColor,
            ),
            onDotClicked: (index) {
              pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 128.0, top: 44.0),
            child: RichText(
              text: TextSpan(
                text: subTitle1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: AppColors.mentalOnboardTextColor,
                ),
                children: [
                  TextSpan(
                    text: subTitle2,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(height: 60.0),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  top: 18.0, left: 18.0, right: 18.0, bottom: 18.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: AppColors.mentalBrandColor,
              ),
              child: Center(
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                    color: AppColors.mentalBrandLightColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
