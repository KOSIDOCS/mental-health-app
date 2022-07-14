import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/chats/application/chats_controller.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatsController _chatsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: 65.0,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 17.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackButton(),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Column(
                              children: [
                                Text(
                                  'Ivanova Maria',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0,
                                      ),
                                ),
                                Text(
                                  'online',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        color: AppColors.mentalBrandColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.asset(
                              'assets/images/${ImagesPlaceHolders.kPsyPlaceholder1}',
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.mentalBarUnselected,
                      thickness: 0.3,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 80.0,
              left: 60.0,
              child: buildChats(),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.83,
              bottom: 0.0,
              child: Container(
                height: 75.0,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Divider(
                      color: AppColors.mentalBarUnselected,
                      thickness: 0.3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.25,
                        vertical: 6.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/${BrandImages.kIconAttach}',
                            height: 22.5,
                            width: 19.88,
                          ),
                          CustomChatField(
                            controller: _chatsController.chatFieldController,
                            keyboardType: TextInputType.text,
                            placeholder: 'Type a message',
                          ),
                          Image.asset(
                            'assets/images/${BrandImages.kIconMic}',
                            height: 22.5,
                            width: 16.88,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChats() {
    return Container(
      width: 300.0,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.mentalBrandColor2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Hello, I don’t know what to do, I don’t want to do anything, nothing makes me happy, how to decide, is it necessary to contact a psychologist?',
            style: TextStyle(
              fontSize: 13.0,
              color: AppColors.mentalChatTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            children: [
              Spacer(),
              SizedBox(width: 5.0),
              Text(
                '26.01',
                style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                    color: AppColors.mentalBarUnselected),
              ),
              CustomIcon(),
            ],
          )
        ],
      ),
    );
  }
}
