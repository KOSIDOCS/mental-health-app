import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/consultations/widgets/custom_appoinment_card.dart';
import 'package:mental_health_care_app/consultations/widgets/details_map.dart';
import 'package:mental_health_care_app/core/custom_ui_state/custom_stateful_ui_state.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

class ConsultationDetailsScreen extends StatefulWidget {
  const ConsultationDetailsScreen({Key? key}) : super(key: key);

  @override
  _ConsultationDetailsScreenState createState() =>
      _ConsultationDetailsScreenState(Duration(seconds: 2));
}

class _ConsultationDetailsScreenState
    extends CustomStatefulUIState<ConsultationDetailsScreen> {
  _ConsultationDetailsScreenState(Duration animationDuration)
      : super(animationDuration);
  @override
  Widget build(BuildContext context) {
    final changeBtns =
        Get.arguments.type == CustomText.kConsultationScreenFilter1;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customSizedBox(context: context, size: 0.04),
              Row(
                children: [
                  BackButton(),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                  Text(
                    CustomText.kConsultationDetailsTitle,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                        ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: CustomSpacing.kBottomSmall,
                  top: CustomSpacing.kHorizontalPad,
                ),
                child: Text(
                  CustomText.kConsultationDetailsSubTitle,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                      ),
                ),
              ),
              SizedBox(height: 10.0),
              CustomUserCard(
                image: Get.arguments.psychologistImage,
                name: Get.arguments.name,
                date: Get.arguments.date,
                time: Get.arguments.time,
              ),
              SizedBox(height: 28.0),
              DetailsMap(
                title: 'Date',
                name: Get.arguments.date,
                isCurrency: false,
              ),
              DetailsMap(
                title: 'Time',
                name: Get.arguments.time,
                isCurrency: false,
              ),
              DetailsMap(
                title: 'Price',
                name: Get.arguments.price.toString(),
                isCurrency: true,
              ),
              SizedBox(
                height: 26.0,
              ),
              Container(
                width: 325.0,
                padding: const EdgeInsets.symmetric(
                    horizontal: CustomSpacing.kBottomSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      changeBtns
                          ? CustomText.kConsultationDetailsSubTitle2
                          : CustomText.kConsultationDetailsSubTitle3,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                          ),
                    ),
                   changeBtns ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${Get.arguments.about}',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: AppColors.mentalBarUnselected,
                            ),
                      ),
                    ) : recommendationsText(text: Get.arguments.recommendations),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.22,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomSpacing.kBottomSmall,
                ),
                child: CustomBtn(
                  onPressed: () {},
                  buttonText: changeBtns
                      ? CustomText.kConsultationDetailsBtn1Title
                      : CustomText.kConsultationDetailsBtn3Title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomSpacing.kBottomSmall,
                  vertical: CustomSpacing.kBottomSmall - 6.0,
                ),
                child: CustomBtn(
                  onPressed: () {},
                  buttonText: changeBtns
                      ? CustomText.kConsultationDetailsBtn2Title
                      : CustomText.kConsultationDetailsBtn4Title,
                  isBorder: true,
                  btnColor: Theme.of(context).scaffoldBackgroundColor,
                  textColor: changeBtns
                      ? AppColors.mentalRed
                      : AppColors.mentalBrandColor,
                  borderColor: changeBtns
                      ? AppColors.mentalRed
                      : AppColors.mentalBrandColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget recommendationsText({ required String text }) {
    if (text.length > 0) {
      return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: AppColors.mentalBarUnselected,
                            ),
                      ),
                    );
    } else {
      return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        CustomText.kConsultationDetailsSubTitle4,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: AppColors.mentalBarUnselected,
                            ),
                      ),
                    );
    }
  }
}
