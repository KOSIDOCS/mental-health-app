import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:table_calendar/table_calendar.dart';

class AdmissionScreen extends StatefulWidget {
  const AdmissionScreen({Key? key}) : super(key: key);

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  BackButton(),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                  Text(
                    CustomText.mentalAdmissionPageTitle,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                        ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23.0, left: 10.0, right: 10.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: AppColors.mentalBrandColor,
                      shape: BoxShape.circle
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
