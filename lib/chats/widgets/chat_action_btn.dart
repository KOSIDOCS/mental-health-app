import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';

class ChatActionBtn extends StatelessWidget {
  final String btnText;
  final IconData icon;
  const ChatActionBtn({Key? key, required this.btnText, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.mentalBrandColor,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Text(btnText),
      ],
    );
  }
}
