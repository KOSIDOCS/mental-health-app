import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/profile/application/profile_main_controller.dart';
import 'package:mental_health_care_app/profile/widgets/profie_edit_card.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/utils/extentions_utils.dart';
import 'package:mental_health_care_app/utils/focus_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final initFuture = FlutterLibphonenumber().init();
  final ProfileMainController _profileController = Get.find();

  /// Used to format numbers as mobile or land line
  var globalPhoneType = PhoneNumberType.mobile;

  /// Use international or national phone format
  var globalPhoneFormat = PhoneNumberFormat.international;

  /// Current selected country
  var currentSelectedCountry = CountryWithPhoneCode(
    countryName: 'United Arab Emirates',
    countryCode: 'AE',
    phoneCode: '971',
    exampleNumberMobileNational: '050 256 5074',
    exampleNumberMobileInternational: '+971 50 256 5074',
    exampleNumberFixedLineInternational: '+97 505 5074',
    phoneMaskMobileInternational: '+000 00 000 0000',
    phoneMaskFixedLineInternational: '+00 000 0000',
    phoneMaskFixedLineNational: '000 000 0000',
    phoneMaskMobileNational: '000 000 0000',
    exampleNumberFixedLineNational: '050 256 5074',
  );

  var inputContainsCountryCode = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context: context);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Row(
                children: [
                  BackButton(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                  ),
                  Center(
                    child: Text(
                      CustomText.kmentalProfileEditTitle,
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32.0,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    ImagesPlaceHolders.kPsyPlaceholder2,
                    height: 85.0,
                    width: 85.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 7.0,
              ),
              Center(
                child: Text(
                  CustomText.kmentalProfileEditPhotoText,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: AppColors.mentalBarUnselected,
                      ),
                ),
              ),
              SizedBox(
                height: 23.0,
              ),

              /// Name field
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
                  controller: _profileController.nameEditController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  validator: (String? value) {
                    if (value!.isEmpty == true) {
                      return CustomErrorText.invalidName;
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(
                height: 23.0,
              ),

              /// Email field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  CustomText.kmentalProfileEditEmail,
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
                  controller: _profileController.emailEditController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  validator: (String? value) {
                    if (value!.isValidEmail == false) {
                      return CustomErrorText.invalidEmail;
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(
                height: 23.0,
              ),

              /// Phone field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  CustomText.kmentalProfileEditPhone,
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
                  controller: _profileController.phoneEditController,
                  keyboardType: TextInputType.phone,
                  obscureText: false,
                  validator: (String? value) {
                    if (value!.isEmpty == true) {
                      return CustomErrorText.invalidPhone;
                    }
                    return null;
                  },
                  inputformatters: [
                    LibPhonenumberTextFormatter(
                      phoneNumberType: globalPhoneType,
                      phoneNumberFormat: globalPhoneFormat,
                      country: currentSelectedCountry,
                      inputContainsCountryCode: inputContainsCountryCode,
                      additionalDigits: 0,
                      shouldKeepCursorAtEndOfInput: true,
                    ),
                  ],
                ),
              ),

              ProfileEditCard(
                title: CustomText.kmentalProfileBtnTitle5,
                onTap: () {},
                isShowChevrone: true,
                isShowDivider: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
