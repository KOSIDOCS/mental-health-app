import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/home/application/home_controller.dart';
import 'package:mental_health_care_app/makeappointment/application/make_appointment_controller.dart';
import 'package:mental_health_care_app/makeappointment/widgets/appointment_user_card.dart';
import 'package:mental_health_care_app/makeappointment/widgets/payment_options.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/utils/focus_helper.dart';
import 'package:mental_health_care_app/utils/time_formatter.dart';

class MakeAppointmentScreen extends StatefulWidget {
  const MakeAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<MakeAppointmentScreen> createState() => _MakeAppointmentScreenState();
}

class _MakeAppointmentScreenState extends State<MakeAppointmentScreen> {
  final HomeController homeController = Get.find();
  final MakeAppointmentController makeAppointmentController = Get.find();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BackButton(),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                    Text(
                      CustomText.mentalMakeAppointmentTitle,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                          ),
                    ),
                  ],
                ),
                AppointmentUserCard(
                  name: homeController.selectedPsychologist.value!.name,
                  imageUrl: homeController.selectedPsychologist.value!.userImage,
                  availability: TimFormatter.formatTimeUserCard(dateTime: homeController.selectedPsychologist.value!.earlyAdmit),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    CustomText.mentalMakeAppointmentInputName,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: AppColors.mentalBarUnselected,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomInputTextField(
                    controller: makeAppointmentController.userNameController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator: (String? value) {
                      if (value!.isEmpty == true) {
                        return CustomErrorText.invalidName;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 39.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    CustomText.mentalMakeAppointmentPaymentSection,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: AppColors.mentalBarUnselected,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 19.0, top: 18.0, bottom: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return PaymentOptions(
                        imageIcon: BrandImages.kApplePay,
                        title: CustomText.mentalApplePayText,
                        optionType: 'Apple Pay',
                        isSelected: makeAppointmentController.selectedPaymentOption.value == 'Apple Pay',
                        onTap: () {
                          makeAppointmentController.selectedPaymentOption('Apple Pay');
                        },
                      );
                      }),
                     Obx(() {
                      return  PaymentOptions(
                        imageIcon: BrandImages.kGoogleIconName,
                        title: CustomText.mentalGooglePayText,
                        optionType: 'Google Pay',
                        isSelected: makeAppointmentController.selectedPaymentOption.value == 'Google Pay',
                        onTap: () {
                          makeAppointmentController.selectedPaymentOption('Google Pay');
                        },
                      );
                     }),
                      Obx(() {
                        return PaymentOptions(
                        imageIcon: BrandImages.kCardPay,
                        title: CustomText.kDummyCardNumber1
                            .replaceRange(0, 12, '**** '),
                        optionType: 'Card1',
                        isSelected: makeAppointmentController.selectedPaymentOption.value == 'Card1',
                        onTap: () {
                          makeAppointmentController.selectedPaymentOption('Card1');
                        },
                      );
                      }),
                      Obx(() {
                        return PaymentOptions(
                        imageIcon: BrandImages.kCardPay,
                        title: CustomText.kDummyCardNumber2
                            .replaceRange(0, 12, '**** '),
                        optionType: 'Card2',
                        isSelected: makeAppointmentController.selectedPaymentOption.value == 'Card2',
                        onTap: () {
                          makeAppointmentController.selectedPaymentOption('Card2');
                        },
                      );
                      }),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 19.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 26.0,
                          color: AppColors.mentalBrandColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: Text(
                            CustomText.kAddCardText,
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: AppColors.mentalBrandColor,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 19.0,
                    right: 19.0,
                    top: MediaQuery.of(context).size.height * 0.14,
                  ),
                  child: CustomBtn(
                    onPressed: () {
                      Get.toNamed('/makeappointment');
                    },
                    buttonText: 'Pay 500 ₴',
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
