import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/uis/custom_modals.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';
import 'package:mental_health_care_app/utils/focus_helper.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({Key? key}) : super(key: key);

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final AuthController authController = Get.put(AuthController());

  final loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                  customSizedBox(context: context, size: 0.15),
                  Obx(
                    () => authController.disableSignInbutton.value
                        ? showSpinner()
                        : Container(),
                  ),
                  mainHeading(
                    text: CustomText.mentalSignInText,
                    context: context,
                  ),
                  customSizedBox(context: context, size: 0.04),
                  Form(
                    key: loginFormKey,
                    child: Column(
                      children: [
                        CustomInputTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          validator: (String? value) {
                            if (!value!.isEmail) {
                              return CustomErrorText.invalidEmail;
                            }
                            return null;
                          },
                          hintText: 'Email',
                        ),
                        CustomInputPassword(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscuringCharacter: '*',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return CustomErrorText.invalidPassword;
                            }
                            return null;
                          },
                          hintText: 'Password',
                        ),
                        customSizedBox(context: context, size: 0.013),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Get.toNamed('/forgot-password'),
                              child: Text(
                                CustomText.mentalForgotPasswordText,
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.button,
                              ),
                            )
                          ],
                        ),
                        customSizedBox(context: context, size: 0.12),
                        Obx(
                          () => AbsorbPointer(
                            absorbing: authController.disableSignInbutton.value,
                            child: CustomBtn(
                              onPressed: () => {
                                if (loginFormKey.currentState!.validate())
                                  {
                                    authController.signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    )
                                  }
                              },
                              buttonText: CustomText.mentalSignInText,
                            ),
                          ),
                        ),
                        customSizedBox(context: context, size: 0.13),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              CustomText.mentalSocialSignUpText,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomCirclerBtn(
                                  onPressed: () => {
                                    authController.googleSignIn(),
                                  },
                                  imgName: BrandImages.kGoogleIconName,
                                  redus: 18.0,
                                  bagroundRadius: 20.0,
                                ),
                                CustomCirclerBtn(
                                  onPressed: () => {
                                    authController.facebookSignIn(),
                                  },
                                  imgName: BrandImages.kFacebookIconName,
                                  redus: 18.0,
                                  bagroundRadius: 20.0,
                                ),
                                CustomCirclerBtn(
                                  onPressed: () => {
                                    authController.signInWithApple(),
                                  },
                                  imgName: BrandImages.kAppleIconName,
                                  redus: 18.0,
                                  bagroundRadius: 20.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                        customSizedBox(context: context, size: 0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              CustomText.mentalSignInNoAcctText,
                              style: Theme.of(context).textTheme.button,
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed('/signup'),
                              child: Text(
                                CustomText.mentalSignUpText,
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
