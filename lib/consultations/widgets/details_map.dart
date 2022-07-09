import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

class DetailsMap extends StatelessWidget {
  final String title;
  final String name;
  final bool isCurrency;
  const DetailsMap(
      {Key? key,
      required this.title,
      required this.name,
      required this.isCurrency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: CustomSpacing.kBottomSmall,
        right: CustomSpacing.kBottomSmall,
      ),
      padding: EdgeInsets.only(top: 3.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      color: AppColors.mentalBarUnselected,
                    ),
              ),
              Spacer(),
              Text(
                '$name ${checkCurrency(isCurrency, context)}',
                style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 11.0,
          ),
          Divider(
            color: AppColors.mentalBarUnselected,
            thickness: 0.35,
          )
        ],
      ),
    );
  }

  String checkCurrency(bool type, BuildContext context) {
    if (type) {
      Locale locale = Localizations.localeOf(context);
      var format = NumberFormat.simpleCurrency(locale: locale.toString());
      return format.currencySymbol;
    } else {
      return '';
    }
  }
}
