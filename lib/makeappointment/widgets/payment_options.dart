import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';

class PaymentOptions extends StatelessWidget {
  final String imageIcon;
  final String title;
  final double? bottomPadding;
  final String optionType;
  final bool isSelected;
  final VoidCallback onTap;
  const PaymentOptions({Key? key, required this.imageIcon, required this.title, this.bottomPadding = 16.0, required this.optionType, required this.isSelected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 19.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/${imageIcon}.png',
                  height: 30.0,
                  width: 30.0,
                  // fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                Spacer(),
                isSelected ? Icon(Icons.check, color: AppColors.mentalBrandColor, size: 22.0) : Container(),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1.0,
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
