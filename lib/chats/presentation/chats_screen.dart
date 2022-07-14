import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/chats/application/chats_controller.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final ChatsController _chatsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: CustomSpacing.kBottomSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customSizedBox(context: context, size: 0.06),
              mainHeading(text: CustomText.kChatTitle, context: context),
              customSizedBox(context: context, size: 0.02),
              CustomSearchBar(
                controller: _chatsController.searchController,
                keyboardType: TextInputType.text,
                placeholder: 'Search',
                onChanged: (String? value) {
                  print(value);
                },
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/chats/chat-room');
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                              EdgeInsets.only(bottom: CustomSpacing.kBottomSmall),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image.asset(
                                      'assets/images/${ImagesPlaceHolders.kPsyPlaceholder1}',
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.78,
                                        padding: EdgeInsets.only(
                                          left: CustomSpacing.kBottomSmall - 2,
                                          bottom: 9.0,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Drozdov Pavel',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17.0,
                                                  ),
                                            ),
                                            Spacer(),
                                            CustomIcon(),
                                            SizedBox(width: 5.0),
                                            Text(
                                              '26.01',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 13.0,
                                                      color: AppColors
                                                          .mentalBarUnselected),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 241.0,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  CustomSpacing.kBottomSmall - 2),
                                          child: Text(
                                            'Yes, I recommend that you get tested as soon as possible, because your...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0,
                                                  color: AppColors
                                                      .mentalBarUnselected,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 13.0),
                              Divider(
                                color: AppColors.mentalBarUnselected,
                                thickness: 0.4,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
