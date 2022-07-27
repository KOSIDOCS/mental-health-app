import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/uis/custom_modals.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';
import 'package:mental_health_care_app/utils/extentions_utils.dart';
import 'package:mental_health_care_app/utils/focus_helper.dart';

class AuthPasswordRecoveryScreen extends StatefulWidget {
  const AuthPasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  State<AuthPasswordRecoveryScreen> createState() =>
      _AuthPasswordRecoveryScreenState();
}

class _AuthPasswordRecoveryScreenState
    extends State<AuthPasswordRecoveryScreen> {
  late TextEditingController emailController;

  final AuthController authController = Get.put(AuthController());

  final forgotFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
                  Obx(
                    () => authController.disableResetPassword.value
                        ? showSpinner()
                        : Container(),
                  ),
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
                    key: forgotFormKey,
                    child: Column(
                      children: [
                        CustomInputTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          validator: (String? value) {
                            if (value!.isValidEmail == false) {
                              return CustomErrorText.invalidEmail;
                            }
                            return null;
                          },
                          hintText: 'Email',
                        ),
                        customSizedBox(context: context, size: 0.12),
                        Obx(
                          () => AbsorbPointer(
                            absorbing:
                                authController.disableResetPassword.value,
                            child: CustomBtn(
                              onPressed: () {
                                if (forgotFormKey.currentState!.validate()) {
                                  authController.userForgotPassword(
                                      email: emailController.text,
                                      context: context);
                                  emailController.clear();
                                }
                              },
                              buttonText: CustomText.mentalPasswordResetBtnText,
                            ),
                          ),
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
