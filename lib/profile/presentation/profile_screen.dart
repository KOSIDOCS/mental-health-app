import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/profile/application/profile_main_controller.dart';
import 'package:mental_health_care_app/profile/widgets/profie_edit_card.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';
import 'package:mental_health_care_app/utils/alignment_helpers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileMainController _profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isProfileImage = _profileController.getUser!.photoUrl.isNotEmpty;
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: leftAligned(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: CustomSpacing.kHorizontalPad,
                ),
                child: mainHeading(
                  text: CustomText.kmentalProfileScreenTitle,
                  context: context,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: CustomSpacing.kHorizontalPad,
                  top: 21.0,
                  right: CustomSpacing.kHorizontalPad,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: isProfileImage
                          ? CachedNetworkImage(
                              imageUrl: _profileController.getUser!.photoUrl,
                              placeholder: (context, url) => CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              height: 80,
                              width: 80,
                            )
                          : Image.asset(
                              ImagesPlaceHolders.kPsyPlaceholder2,
                              height: 80.0,
                              width: 80.0,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _profileController.getUser!.name.isEmpty
                              ? CustomText.kmentalProfileScreenNameMissing
                              : _profileController.getUser!.name,
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0,
                                  ),
                        ),
                        Text(
                          _profileController.getUser!.email.isEmpty
                              ? CustomText.kmentalProfileScreenEmailMissing
                              : _profileController.getUser!.email,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.0,
                                color: AppColors.mentalBarUnselected,
                              ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/profile/profile-edit');
                      },
                      child: Image.asset(
                        BrandImages.kIconEditIcon,
                        height: 20.0,
                        width: 20.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              ProfileEditCard(
                image: BrandImages.kIconBookmark,
                title: CustomText.kmentalProfileBtnTitle,
                onTap: () {},
                isShowChevrone: true,
                isShowDivider: true,
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigation(),
      ),
    );
  }
}
