import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
class AppointmentUserCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String availability;
  const AppointmentUserCard({Key? key, required this.name, required this.imageUrl, required this.availability}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0, left: 16.0),
                      child: Image.network(
                        imageUrl,
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
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 14.0),
                          child: Text(
                            availability,
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.0,
                                      color: AppColors.mentalBarUnselected,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
  }
}