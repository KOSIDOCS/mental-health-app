import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/chats/application/chat_home_controller.dart';
import 'package:mental_health_care_app/chats/model/message_chat.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/uis/custom_text.dart';
import 'package:mental_health_care_app/uis/spacing.dart';
import 'package:mental_health_care_app/utils/focus_helper.dart';
import 'package:mental_health_care_app/utils/time_formatter.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final ChatHomeController _chatHomeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context: context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: CustomSpacing.kBottomSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customSizedBox(context: context, size: 0.06),
                mainHeading(text: CustomText.kChatTitle, context: context),
                customSizedBox(context: context, size: 0.02),
                CustomSearchBar(
                  controller: _chatHomeController.searchController,
                  keyboardType: TextInputType.text,
                  placeholder: 'Search',
                  onChanged: (String? value) {
                    _chatHomeController.searchUsers();
                  },
                ),
                Expanded(child: Obx(() {
                  return ListView.builder(
                      itemCount: _chatHomeController.conversationUsers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _chatHomeController.openGroupChat(
                              user: _chatHomeController
                                  .conversationUsers[index].user,
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    bottom: CustomSpacing.kBottomSmall),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          child: CachedNetworkImage(
                                            imageUrl: _chatHomeController
                                                .conversationUsers[index]
                                                .user
                                                .userImage,
                                            placeholder: (context, url) =>
                                                CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            height: 60,
                                            width: 60,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.78,
                                              padding: EdgeInsets.only(
                                                left:
                                                    CustomSpacing.kBottomSmall -
                                                        2,
                                                bottom: 9.0,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _chatHomeController
                                                        .conversationUsers[
                                                            index]
                                                        .user
                                                        .name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17.0,
                                                        ),
                                                  ),
                                                  Spacer(),
                                                  CustomIcon(
                                                    isRead: _chatHomeController
                                                        .conversationUsers[
                                                            index]
                                                        .lastChat
                                                        .readMessage,
                                                  ),
                                                  SizedBox(width: 5.0),
                                                  Text(
                                                    TimFormatter.formatChatTime(
                                                        int.parse(
                                                            _chatHomeController
                                                                .conversationUsers[
                                                                    index]
                                                                .lastChat
                                                                .timestamp)),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 13.0,
                                                            color: AppColors
                                                                .mentalBarUnselected),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            showLastMessage(
                                              message: _chatHomeController
                                                  .conversationUsers[index]
                                                  .lastChat,
                                            )
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
                              Obx(() {
                                return _chatHomeController
                                            .conversationUsers[index]
                                            .unreadMessagesCount != 0 ? Transform.translate(
                                  offset: Offset(
                                    MediaQuery.of(context).size.width * 0.86,
                                    MediaQuery.of(context).size.height * 0.035,
                                  ),
                                  child: CircleAvatar(
                                    radius: 12.0,
                                    backgroundColor: AppColors.mentalBrandColor,
                                    child: Center(
                                      child: Text(
                                        _chatHomeController
                                            .conversationUsers[index]
                                            .unreadMessagesCount
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              color: AppColors.mentalPureWhite,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ) : Container();
                              })
                            ],
                          ),
                        );
                      });
                })),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigation(),
      ),
    );
  }

  Widget showLastMessage({required MessageChat message}) {
    switch (message.type) {
      case TypeMessage.IMAGE:
        return customLastSnippet();
      case TypeMessage.FILE:
        return customLastSnippet(
          text: CustomText.kmentalLastChatDocument,
          icon: Icons.file_present,
        );
      case TypeMessage.VIDEO:
        return customLastSnippet(
          text: CustomText.kmentalLastChatVideo,
          icon: Icons.video_file,
        );
      case TypeMessage.GIPHY:
        return customLastSnippet(
          text: CustomText.kmentalLastChatGiphy,
          icon: Icons.gif,
        );
      case TypeMessage.AUDIO:
        return customLastSnippet(
          text: CustomText.kmentalLastChatVoice,
          icon: Icons.audio_file_outlined,
        );  
      default:
        return SizedBox(
          width: 241.0,
          child: Padding(
            padding: EdgeInsets.only(left: CustomSpacing.kBottomSmall - 2),
            child: Text(
              message.content,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                    color: AppColors.mentalBarUnselected,
                  ),
            ),
          ),
        );
    }
  }

  Widget customLastSnippet(
      {String? text = CustomText.kmentalLastChatPhoto,
      IconData? icon = Icons.image}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(children: [
        Icon(
          icon,
          color: AppColors.mentalBarUnselected,
          size: 26.4,
        ),
        Text(
          text!,
          style: Theme.of(context).textTheme.caption!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 15.0,
                color: AppColors.mentalBarUnselected,
              ),
        ),
      ]),
    );
  }
}
