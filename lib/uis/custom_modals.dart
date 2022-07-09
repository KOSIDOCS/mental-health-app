import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

void customBottomSheet(
    {required BuildContext context,
    required String title,
    required Widget content,
    required VoidCallback onPressed}) {
  showModalBottomSheet(
    context: context,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.38,
      minWidth: MediaQuery.of(context).size.width,
    ),
    builder: (BuildContext contextModal) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: CustomSpacing.kHorizontalPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 8.0),
                height: 6.0,
                width: 120.0,
                decoration: BoxDecoration(
                  color: AppColors.mentalOnboardTextColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            customSizedBox(context: contextModal, size: 0.04),
            mainHeading(
              text: CustomText.mentalModalCheckEmailText,
              context: contextModal,
            ),
            customSizedBox(context: contextModal, size: 0.01),
            subHeadingTextLarge(
              text: CustomText.mentalModalCheckEmailSubText,
              context: contextModal,
            ),
            customSizedBox(context: contextModal, size: 0.04),
            CustomBtn(
              onPressed: onPressed,
              buttonText: CustomText.mentalModalCheckEmailBtnText,
            ),
            customSizedBox(context: contextModal, size: 0.01),
            CustomBtn(
              onPressed: () => Navigator.pop(contextModal),
              buttonText: CustomText.mentalModalCheckEmailCloseBtnText,
              btnColor: AppColors.mentalBrandLightColor,
              textColor: AppColors.mentalBrandColor,
            ),
          ],
        ),
      );
    },
  );
}

Widget showSpinner() {
  return Container(
    child: Center(
      child: SpinKitDualRing(
        color: AppColors.mentalBrandColor,
        size: 50.0,
      ),
    ),
  );
}

void showSearchBottomSheet(
    {required BuildContext context,
    required VoidCallback onPressed,
    required List list,
    required dynamic controller}) {
  showModalBottomSheet(
    context: context,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.45,
      minWidth: MediaQuery.of(context).size.width,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    builder: (BuildContext contextModal) {
      return Container(
        // padding: EdgeInsets.symmetric(horizontal: CustomSpacing.kHorizontalPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 8.0),
                height: 6.0,
                width: 120.0,
                decoration: BoxDecoration(
                  color: AppColors.mentalOnboardTextColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 46),
            Obx(() {
              return CustomTextBtn(
                text: CustomText.mentalBottomSearchText1,
                isBorder: true,
                onPressed: () {
                  controller
                      .addBottomSearchParam(CustomText.mentalBottomSearchText1);
                },
                isSelected: controller
                    .checkFilterExists(CustomText.mentalBottomSearchText1),
              );
            }),
            Obx(() {
              return CustomTextBtn(
                text: CustomText.mentalBottomSearchText2,
                isBorder: true,
                onPressed: () {
                  controller
                      .addBottomSearchParam(CustomText.mentalBottomSearchText2);
                },
                isSelected: controller
                    .checkFilterExists(CustomText.mentalBottomSearchText2),
              );
            }),
            Obx(() {
              return CustomTextBtn(
                text: CustomText.mentalBottomSearchText3,
                isBorder: true,
                onPressed: () {
                  controller
                      .addBottomSearchParam(CustomText.mentalBottomSearchText3);
                },
                isSelected: controller
                    .checkFilterExists(CustomText.mentalBottomSearchText3),
              );
            }),
            Obx(() {
              return CustomTextBtn(
                text: CustomText.mentalBottomSearchText4,
                isBorder: true,
                onPressed: () {
                  controller
                      .addBottomSearchParam(CustomText.mentalBottomSearchText4);
                },
                isSelected: controller
                    .checkFilterExists(CustomText.mentalBottomSearchText4),
              );
            }),
            Obx(() {
              return CustomTextBtn(
                text: CustomText.mentalBottomSearchText5,
                isBorder: true,
                onPressed: () {
                  controller
                      .addBottomSearchParam(CustomText.mentalBottomSearchText5);
                },
                isSelected: controller
                    .checkFilterExists(CustomText.mentalBottomSearchText5),
              );
            }),
            SizedBox(height: 15.0),
            Divider(
              thickness: 1,
              color: AppColors.mentalSearchBar,
            ),
            SizedBox(height: 15.0),
            Container(
              margin: EdgeInsets.only(
                  left: CustomSpacing.kHorizontalPad,
                  right: CustomSpacing.kHorizontalPad),
              child: Row(
                children: [
                  CustomBtn(
                    onPressed: () => controller.clearBottomSearch(),
                    buttonText: CustomText.mentalBottomSearchButton1,
                    btnColor: AppColors.mentalBrandLightColor,
                    textColor: AppColors.mentalBrandColor,
                    width: 163.0,
                    isBorder: true,
                    padding: EdgeInsets.all(10.0),
                  ),
                  Spacer(),
                  CustomBtn(
                    onPressed: () => controller.bottomSearchFilter(),
                    buttonText: CustomText.mentalBottomSearchButton2,
                    btnColor: AppColors.mentalBrandColor,
                    textColor: AppColors.mentalBrandLightColor,
                    width: 163.0,
                    padding: EdgeInsets.all(10.0),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Search filter for consultation Screen
/// [context] - context of the screen
/// [onPressed] - onPressed function for the button
/// [controller] - controller for the search filter
void showConsultationFilter(
    {required BuildContext context,
    required VoidCallback onPressed,
    required dynamic controller}) {
  showModalBottomSheet(
    context: context,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.33,
      minWidth: MediaQuery.of(context).size.width,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    builder: (BuildContext contextModal) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 8.0),
                height: 6.0,
                width: 120.0,
                decoration: BoxDecoration(
                  color: AppColors.mentalOnboardTextColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 22.0, bottom: 10.0, top: 15.0),
              child: Text(
                CustomText.kConsultationScreenFilterTitle,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
              ),
            ),
            // const SizedBox(height: 46),
            Obx(() {
              return CustomTextBtn(
                text: CustomText.kConsultationScreenFilter1,
                isBorder: true,
                onPressed: () {
                  controller.addBottomSearchParam(
                      CustomText.kConsultationScreenFilter1);
                },
                isSelected: controller
                    .checkFilterExists(CustomText.kConsultationScreenFilter1),
                textColor: controller.checkFilterExists(
                        CustomText.kConsultationScreenFilter1)
                    ? AppColors.mentalBrandColor
                    : AppColors.mentalDarkColor,
              );
            }),
            Obx(() {
              return CustomTextBtn(
                text: CustomText.kConsultationScreenFilter2,
                isBorder: true,
                onPressed: () {
                  controller.addBottomSearchParam(
                      CustomText.kConsultationScreenFilter2);
                },
                isSelected: controller
                    .checkFilterExists(CustomText.kConsultationScreenFilter2),
                    textColor: controller.checkFilterExists(
                        CustomText.kConsultationScreenFilter2)
                    ? AppColors.mentalBrandColor
                    : AppColors.mentalDarkColor,
              );
            }),
            Obx(() {
              return CustomTextBtn(
                text: CustomText.kConsultationScreenFilter3,
                isBorder: false,
                onPressed: () {
                  controller.addBottomSearchParam(
                      CustomText.kConsultationScreenFilter3);
                },
                isSelected: controller
                    .checkFilterExists(CustomText.kConsultationScreenFilter3),
                    textColor: controller.checkFilterExists(
                        CustomText.kConsultationScreenFilter3)
                    ? AppColors.mentalBrandColor
                    : AppColors.mentalDarkColor,
              );
            }),
            SizedBox(height: 15.0),
            Divider(
              thickness: 1,
              color: AppColors.mentalSearchBar,
            ),
            SizedBox(height: 15.0),
            Container(
              margin: EdgeInsets.only(
                  left: CustomSpacing.kHorizontalPad,
                  right: CustomSpacing.kHorizontalPad),
              child: Row(
                children: [
                  CustomBtn(
                    onPressed: () => controller.clearBottomSearch(),
                    buttonText: CustomText.mentalBottomSearchButton1,
                    btnColor: AppColors.mentalBrandLightColor,
                    textColor: AppColors.mentalBrandColor,
                    width: 163.0,
                    isBorder: true,
                    padding: EdgeInsets.all(10.0),
                  ),
                  Spacer(),
                  CustomBtn(
                    onPressed: () => controller.bottomSearchFilter(),
                    buttonText: CustomText.mentalBottomSearchButton2,
                    btnColor: AppColors.mentalBrandColor,
                    textColor: AppColors.mentalBrandLightColor,
                    width: 163.0,
                    padding: EdgeInsets.all(10.0),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
