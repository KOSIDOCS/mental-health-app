import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/consultations/application/consultation_controller.dart';
import 'package:mental_health_care_app/consultations/widgets/custom_appoinment_card.dart';
import 'package:mental_health_care_app/core/custom_ui_state/custom_stateful_ui_state.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_modals.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({Key? key}) : super(key: key);

  @override
  _ConsultationScreenState createState() =>
      _ConsultationScreenState(Duration(seconds: 2));
}

class _ConsultationScreenState
    extends CustomStatefulUIState<ConsultationScreen> {
  _ConsultationScreenState(Duration animationDuration)
      : super(animationDuration);

  final ConsultationController consultationController = Get.find();

  @override
  void initState() {
    super.initState();
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            customSizedBox(context: context, size: 0.04),
            Row(
              children: [
                AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: mainHeadingAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: CustomSpacing.kHorizontalPad,
                          ),
                          child: mainHeading(
                            text: CustomText.kConsultationScreenTitle,
                            context: context,
                          ),
                        ),
                      );
                    }),
                Spacer(),
                AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Container(
                        padding: EdgeInsets.only(
                          right: CustomSpacing.kHorizontalPad,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showConsultationFilter(
                              context: context,
                              controller: consultationController,
                              onPressed: () {},
                            );
                          },
                          child: ImageIcon(
                            AssetImage(
                                'assets/images/${BrandImages.kIconUnion}'),
                            color: Theme.of(context).iconTheme.color,
                            size: searchIconAnimation.value * 30.0,
                          ),
                        ),
                      );
                    })
              ],
            ),
            SizedBox(
              height: 20.5,
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 0.8,
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: bodyAnimation.value,
                    child: Obx(() {
                      return ListView.builder(
                        itemCount:
                            consultationController.allConsultation.length,
                        itemBuilder: ((context, index) {
                          return CustomAppointmentCard(
                            name: consultationController
                                .allConsultation[index].name,
                            image: consultationController
                                .allConsultation[index].psychologistImage,
                            type: consultationController
                                .allConsultation[index].type,
                            onPressed: () {
                              consultationController.pushToDetailsScreen(
                                  consultationController
                                      .allConsultation[index]);
                            },
                            date: consultationController
                                .allConsultation[index].date,
                            time: consultationController
                                .allConsultation[index].time,
                          );
                        }),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
