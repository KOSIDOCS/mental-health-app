import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';

class CustomBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color? btnColor;
  final Color? textColor;
  const CustomBtn(
      {Key? key,
      required this.onPressed,
      required this.buttonText,
      this.btnColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding:
            EdgeInsets.only(top: 18.0, left: 18.0, right: 18.0, bottom: 18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: btnColor ?? AppColors.mentalBrandColor,
        ),
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20.0,
              color: textColor ?? AppColors.mentalBrandLightColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCirclerBtn extends StatelessWidget {
  final String imgName;
  final VoidCallback onPressed;
  final double redus;
  final double bagroundRadius;
  const CustomCirclerBtn(
      {Key? key,
      required this.imgName,
      required this.onPressed,
      required this.redus,
      required this.bagroundRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15.0),
      child: GestureDetector(
        onTap: onPressed,
        child: CircleAvatar(
          backgroundColor: AppColors.mentalBrandColor,
          radius: bagroundRadius,
          child: CircleAvatar(
            backgroundColor: AppColors.mentalBrandLightColor,
            radius: redus,
            child: Image.asset(
              'assets/images/$imgName.png',
              fit: BoxFit.contain,
              height: 19.0,
              width: 19.0,
              color: AppColors.mentalBrandColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBottomBars extends StatelessWidget {
  final String iconImage;
  final String title;
  final int id;
  final VoidCallback onPressed;
  final int currentTab;
  const CustomBottomBars(
      {Key? key,
      required this.iconImage,
      required this.title,
      required this.id,
      required this.onPressed,
      required this.currentTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(
            right: id == 5 ? 0.0 : MediaQuery.of(context).size.width * 0.06),
        child: Column(
          children: [
            Image.asset(
              'assets/images/$iconImage',
              width: 28.0,
              height: 28.0,
              color: id == currentTab
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
            ),
            Text(
              title,
              style: TextStyle(
                  color: id == currentTab
                      ? Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedItemColor
                      : Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor),
            ),
          ],
        ),
      ),
    );
  }
}

class BarIcon {
  String icon;
  String titel;
  int id;

  BarIcon(this.icon, this.titel, this.id);
}
