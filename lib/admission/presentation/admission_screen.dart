import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_care_app/admission/application/admission_controller.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:table_calendar/table_calendar.dart';

class AdmissionScreen extends StatefulWidget {
  const AdmissionScreen({Key? key}) : super(key: key);

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  final AdmissionController _admissionController = Get.find();
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;

  List<String> dummyDates = [
    '12:30 – 12:55',
    '14:00 – 14:25',
    '16:30 – 16:55',
    '17:00 – 17:25',
    '18:00 – 18:25',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                padding:
                    const EdgeInsets.only(top: 23.0, left: 10.0, right: 10.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDate,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: AppColors.mentalBrandColor,
                        shape: BoxShape.circle),
                    defaultTextStyle:
                        TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
                    selectedTextStyle: TextStyle(
                        color: AppColors.mentalPureWhite,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.mentalBrandColor, width: 1.0),
                    ),
                    todayTextStyle: TextStyle(
                        color: AppColors.mentalBrandColor,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400),
                  ),
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      formatButtonShowsNext: false,
                      titleCentered: true,
                      headerMargin: EdgeInsets.only(
                        bottom: 33.0,
                      ),
                      leftChevronMargin: EdgeInsets.all(0.0),
                      rightChevronMargin: EdgeInsets.all(0.0),
                      leftChevronPadding: EdgeInsets.all(0.0),
                      rightChevronPadding: EdgeInsets.all(0.0),
                      titleTextFormatter: (dateTime, locale) {
                        return DateFormat.MMMM(locale).format(dateTime);
                      },
                      titleTextStyle: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w400)),
                  selectedDayPredicate: (day) {
                    return day.day == _selectedDate?.day;
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDate = focusedDay;
                      _selectedDate = selectedDay;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 35.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Text(
                  CustomText.mentalAdmissionTimeTitle,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Wrap(
                  spacing: 19.0,
                  children: dummyDates
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Obx(() {
                            return CustomBtn(
                              onPressed: () {
                                _admissionController.setSelectedTime(time: e);
                              },
                              buttonText: e,
                              padding: EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                  top: 15.0,
                                  bottom: 15.0),
                              width: 166.0,
                              fontSize: 13.0,
                              isBorder: true,
                              btnColor:
                                  _admissionController.selectedTime.value == e
                                      ? AppColors.mentalBrandColor
                                      : Theme.of(context).scaffoldBackgroundColor,
                              borderColor:
                                  _admissionController.selectedTime.value == e
                                      ? AppColors.mentalBrandColor
                                      : AppColors.mentalBarUnselected,
                              textColor:
                                  _admissionController.selectedTime.value == e
                                      ? AppColors.mentalPureWhite
                                      : AppColors.mentalBarUnselected,
                              borderSize: 0.3,
                            );
                          }),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 30.0,),
                child: CustomBtn(
                  onPressed: () {
                    Get.toNamed('/makeappointment');
                  },
                  buttonText: CustomText.mentalAdmissionButtonText,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
