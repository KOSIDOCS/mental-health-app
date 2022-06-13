import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/uis/custom_modals.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';
import 'package:mental_health_care_app/utils/focus_helper.dart';

class AuthPasswordRecoveryScreen extends StatefulWidget {
  const AuthPasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  State<AuthPasswordRecoveryScreen> createState() =>
      _AuthPasswordRecoveryScreenState();
}

class _AuthPasswordRecoveryScreenState
    extends State<AuthPasswordRecoveryScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context: context);
      },
      child: Scaffold(
        backgroundColor: AppColors.mentalBrandLightColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: CustomSpacing.kHorizontalPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      size: 25.0,
                    ),
                  ),
                  customSizedBox(context: context, size: 0.1),
                  mainHeading(
                    text: CustomText.mentalPasswordResetText,
                    context: context,
                  ),
                  customSizedBox(context: context, size: 0.03),
                  subHeadingTextLarge(
                    text: CustomText.mentalPasswordResetSubText,
                    context: context,
                  ),
                  customSizedBox(context: context, size: 0.04),
                  Form(
                    // key: GlobalKey(),
                    child: Column(
                      children: [
                        CustomInputTextField(
                          // controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return CustomErrorText.invalidEmail;
                            }
                            return null;
                          },
                        ),
                        customSizedBox(context: context, size: 0.12),
                        CustomBtn(
                          onPressed: () => {
                            customBottomSheet(content: Text('Here is modal'), context: context, title: '', onPressed: () {  },),
                          },
                          buttonText: CustomText.mentalPasswordResetBtnText,
                        ),
                        customSizedBox(context: context, size: 0.33),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              CustomText.mentalPasswordResetBottomText,
                              style: Theme.of(context).textTheme.button,
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Text(
                                CustomText.mentalPasswordResetReturnText,
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(
                                      color: AppColors.mentalBrandColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
