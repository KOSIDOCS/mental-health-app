import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
