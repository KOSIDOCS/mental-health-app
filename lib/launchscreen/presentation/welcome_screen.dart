import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:typewritertext/typewritertext.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mentalDarkColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              CustomText.brand_name_1,
              style: TextStyle(
                color: AppColors.mentalBrandColor,
                fontSize: 32.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(width: 8.0),
            TypeWriterText(
              duration: Duration(milliseconds: 400),
              text: Text(
                CustomText.brand_name_2,
                style: TextStyle(
                  color: AppColors.mentalBrandLightColor,
                  fontSize: 32.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
