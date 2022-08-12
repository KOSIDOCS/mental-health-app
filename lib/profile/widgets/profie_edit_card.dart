import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

class ProfileEditCard extends StatelessWidget {
  final String title;
  final String? image;
  final bool isShowChevrone;
  final VoidCallback onTap;
  final bool isShowDivider;
  const ProfileEditCard({
    Key? key,
    required this.title,
    this.image,
    required this.isShowChevrone,
    required this.onTap,
    required this.isShowDivider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: CustomSpacing.kHorizontalPad,
              left: CustomSpacing.kHorizontalPad,
              top: CustomSpacing.kHorizontalPad,
            ),
            child: Row(
              children: [
                image != null ? Image.asset(
                  'assets/images/${image}',
                  height: 35.0,
                  width: 35.0,
                  fit: BoxFit.cover,
                  color: AppColors.mentalDarkColor,
                ): Container(),
                SizedBox(
                  width: image != null ? 16.0 : 0.0,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                      ),
                ),
                Spacer(),
                isShowChevrone ? Image.asset(
                  'assets/images/${BrandImages.kIconSendIcon}.png',
                  height: 16.0,
                  width: 8.0,
                  fit: BoxFit.cover,
                  color: AppColors.mentalDarkColor,
                ) : Container(),
              ],
            ),
          ),
          isShowDivider ? Padding(
            padding: EdgeInsets.only(
              left: CustomSpacing.kHorizontalPad,
              top: CustomSpacing.kHorizontalPad - 6.0,
            ),
            child: Divider(
              color: AppColors.mentalBarUnselected,
              thickness: 0.3,
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
