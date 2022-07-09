import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';

class CustomAppointmentCard extends StatelessWidget {
  final String image;
  final String name;
  final String type;
  final VoidCallback? onPressed;
  final String date;
  final String time;
  const CustomAppointmentCard(
      {Key? key,
      required this.image,
      required this.name,
      required this.type,
      this.onPressed,
      required this.date,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.5, left: 16.0),
                child: Image.network(
                  image,
                  height: 60.0,
                  width: 60.0,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, left: 14.0),
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, left: 14.0),
                    child: Text(
                      '$date, $time',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.0,
                            color: AppColors.mentalBarUnselected,
                          ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Transform.translate(
                offset: Offset(0.0, -10.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    type,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: type == 'Canceled' ? 13.0 : 11.0,
                          color: typeColor(type: type),
                        ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.5),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.8,
          ),
        ],
      ),
    );
  }
}

class CustomUserCard extends StatelessWidget {
  final String image;
  final String name;
  final String? type;
  final String date;
  final String time;
  const CustomUserCard({Key? key, required this.image, required this.name, this.type, required this.date, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.5, left: 16.0),
          child: Image.network(
            image,
            height: 60.0,
            width: 60.0,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 14.0),
              child: Text(
                name,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 14.0),
              child: Text(
                '$date, $time',
                style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 11.0,
                      color: AppColors.mentalBarUnselected,
                    ),
              ),
            ),
          ],
        ),
        Spacer(),
        type != null ? Transform.translate(
          offset: Offset(0.0, -10.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text(
              type ?? '',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: type == 'Canceled' ? 13.0 : 11.0,
                    color: typeColor(type: type ?? ''),
                  ),
            ),
          ),
        ) : Container(),
      ],
    );
  }
}

Color typeColor({required String type}) {
    switch (type) {
      case 'Planned':
        return AppColors.mentalGreen;
      case 'Finished':
        return AppColors.mentalBarUnselected;
      case 'Canceled':
        return AppColors.mentalRed;
      default:
        return AppColors.mentalBarUnselected;
    }
  }