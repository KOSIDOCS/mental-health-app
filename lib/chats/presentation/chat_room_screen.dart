import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_emoji/dart_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:mental_health_care_app/chats/application/chats_controller.dart';
import 'package:mental_health_care_app/chats/model/message_chat.dart';
import 'package:mental_health_care_app/chats/widgets/chat_action_btn.dart';
import 'package:mental_health_care_app/chats/widgets/chat_bubble.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/home/model/psychologist_model.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/utils/extentions_utils.dart';
import 'package:mental_health_care_app/utils/focus_helper.dart';
import 'package:mental_health_care_app/utils/time_formatter.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen>
    with SingleTickerProviderStateMixin {
  final ChatsController _chatsController = Get.find();
  late AnimationController _animationController;
  late Animation<double> _animationOpacity;

  late PsychologistModel selectedPsychologist;

  //Gif
  late GiphyGif currentGif;

  // Giphy Client
  late GiphyClient client;

  // Random ID
  String randomId = "";

  String giphyApiKey = dotenv.env["GLIPHY"]!;

  @override
  void initState() {
    super.initState();
    selectedPsychologist = Get.arguments;
    client = GiphyClient(apiKey: giphyApiKey, randomId: '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      client.getRandomId().then((value) {
        setState(() {
          randomId = value;
        });
      });
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1300),
    );

    _animationOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GiphyGetWrapper(
      giphy_api_key: dotenv.env['GLIPHY']!,
      builder: (stream, giphyGetWrapper) {
        stream.listen((gif) {
          setState(() {
            currentGif = gif;
            _chatsController.sendGiphy(
              peerId: selectedPsychologist.uid,
              type: TypeMessage.GIPHY,
              context: context,
              giphyGif: currentGif,
            );
            print(currentGif.url);
            print(currentGif);
          });
        });

        return GestureDetector(
          onTap: () => hideKeyboard(context: context),
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
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
                                      selectedPsychologist.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17.0,
                                          ),
                                    ),
                                    Text(
                                      selectedPsychologist.isOnline
                                          ? 'online'
                                          : 'offline',
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
                                child: CachedNetworkImage(
                                  imageUrl: selectedPsychologist.userImage,
                                  placeholder: (context, url) => CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
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
                  Transform.translate(
                    offset: const Offset(0.0, 59.0),
                    child: buildChatsWithDates(),
                  ),
                  Obx(() {
                    return _chatsController.isRecording.value
                        ? Align(
                            alignment: Alignment(0.0, 0.8),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        return Opacity(
                                          opacity: _animationOpacity.value,
                                          child: Icon(
                                            Icons.mic,
                                            color: AppColors.mentalRed,
                                            size: 32.0,
                                          ),
                                        );
                                      }),
                                  // Icon(
                                  //   Icons.mic,
                                  //   color: AppColors.mentalRed,
                                  //   size: 32.0,
                                  // ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  // Text(
                                  //   '00:03',
                                  //   style: Theme.of(context)
                                  //       .textTheme
                                  //       .headline5!
                                  //       .copyWith(
                                  //         color: AppColors.mentalBarUnselected,
                                  //         fontWeight: FontWeight.w500,
                                  //         fontSize: 22.0,
                                  //       ),
                                  // ),
                                  AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        return Opacity(
                                          opacity: _animationOpacity.value,
                                          child: Text(
                                            '00:03',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                  color: AppColors
                                                      .mentalBarUnselected,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 22.0,
                                                ),
                                          ),
                                        );
                                      }),
                                  GestureDetector(
                                    onTap: () {
                                      _chatsController.stop();
                                      _animationController.stop();
                                      _chatsController.closeRecording();
                                    },
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppColors.mentalRed,
                                      size: 32.0,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _chatsController.pause();
                                      _animationController.stop();
                                    },
                                    child: Icon(
                                      Icons.pause,
                                      color: AppColors.mentalRed,
                                      size: 32.0,
                                    ),
                                  ),
                                  CustomCirclerBtn(
                                    imgName: BrandImages.kIconSendIcon,
                                    onPressed: () {
                                      _animationController.stop();
                                      _chatsController.closeRecording();
                                    },
                                    redus: 19.5,
                                    bagroundRadius: 20.0,
                                    imgHeight: 22.5,
                                    imgWidth: 16.88,
                                    padding: const EdgeInsets.all(0.0),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container();
                  }),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 75.0,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).scaffoldBackgroundColor,
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
                                GestureDetector(
                                  onTap: () {
                                    showSendFilesAction(context);
                                  },
                                  child: Image.asset(
                                    'assets/images/${BrandImages.kIconAttach}',
                                    height: 22.5,
                                    width: 19.88,
                                  ),
                                ),
                                CustomChatField(
                                  controller:
                                      _chatsController.chatFieldController,
                                  keyboardType: TextInputType.text,
                                  placeholder: 'Type a message',
                                  onChanged: (String? text) {
                                    if (text!.isEmpty ||
                                        text.runes.length > 200) {
                                      _chatsController.setShowSendButton =
                                          false;
                                    } else if (text.isNotEmpty ||
                                        text.length == 1 ||
                                        EmojiUtil.hasOnlyEmojis(text)) {
                                      _chatsController.setShowSendButton = true;
                                    }
                                  },
                                  openGiphy: () {
                                    giphyGetWrapper.getGif('', context);
                                  },
                                ),
                                Obx(() {
                                  return _chatsController.getShowSendButton
                                      ? CustomCirclerBtn(
                                          imgName: BrandImages.kIconSendIcon,
                                          onPressed: () {
                                            _chatsController.submitChat(
                                                peerId:
                                                    selectedPsychologist.uid);
                                            print(
                                                "Psychologist id: ${selectedPsychologist.uid}");
                                          },
                                          redus: 19.5,
                                          bagroundRadius: 20.0,
                                          imgHeight: 22.5,
                                          imgWidth: 16.88,
                                          padding: const EdgeInsets.all(0.0),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            _chatsController.startRecording();
                                            _animationController.repeat();
                                          },
                                          child: Image.asset(
                                            'assets/images/${BrandImages.kIconMic}',
                                            height: 22.5,
                                            width: 16.88,
                                          ),
                                        );
                                })
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
          ),
        );
      },
    );
    // return GestureDetector(
    //   onTap: () => hideKeyboard(context: context),
    //   child: Scaffold(
    //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //     body: SafeArea(
    //       child: Stack(
    //         children: [
    //           Container(
    //             height: 65.0,
    //             width: MediaQuery.of(context).size.width,
    //             child: Column(
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.only(right: 17.0),
    //                   child: Row(
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       BackButton(),
    //                       Padding(
    //                         padding: const EdgeInsets.only(top: 0.0),
    //                         child: Column(
    //                           children: [
    //                             Text(
    //                               selectedPsychologist.name,
    //                               style: Theme.of(context)
    //                                   .textTheme
    //                                   .headline4!
    //                                   .copyWith(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 17.0,
    //                                   ),
    //                             ),
    //                             Text(
    //                               selectedPsychologist.isOnline
    //                                   ? 'online'
    //                                   : 'offline',
    //                               style: Theme.of(context)
    //                                   .textTheme
    //                                   .headline4!
    //                                   .copyWith(
    //                                     fontWeight: FontWeight.w400,
    //                                     fontSize: 12.0,
    //                                     color: AppColors.mentalBrandColor,
    //                                   ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       ClipRRect(
    //                         borderRadius: BorderRadius.circular(30.0),
    //                         child: CachedNetworkImage(
    //                           imageUrl: selectedPsychologist.userImage,
    //                           placeholder: (context, url) => CircleAvatar(
    //                             backgroundColor:
    //                                 Theme.of(context).scaffoldBackgroundColor,
    //                           ),
    //                           errorWidget: (context, url, error) =>
    //                               Icon(Icons.error),
    //                           height: 40,
    //                           width: 40,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Divider(
    //                   color: AppColors.mentalBarUnselected,
    //                   thickness: 0.3,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Transform.translate(
    //             offset: const Offset(0.0, 59.0),
    //             child: buildChatsWithDates(),
    //           ),
    //           Align(
    //             alignment: Alignment.bottomCenter,
    //             child: Container(
    //               height: 75.0,
    //               width: MediaQuery.of(context).size.width,
    //               color: Theme.of(context).scaffoldBackgroundColor,
    //               child: Column(
    //                 children: [
    //                   Divider(
    //                     color: AppColors.mentalBarUnselected,
    //                     thickness: 0.3,
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(
    //                       horizontal: 20.25,
    //                       vertical: 6.0,
    //                     ),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         GestureDetector(
    //                           onTap: () {
    //                             showSendFilesAction(context);
    //                           },
    //                           child: Image.asset(
    //                             'assets/images/${BrandImages.kIconAttach}',
    //                             height: 22.5,
    //                             width: 19.88,
    //                           ),
    //                         ),
    //                         CustomChatField(
    //                           controller: _chatsController.chatFieldController,
    //                           keyboardType: TextInputType.text,
    //                           placeholder: 'Type a message',
    //                           onChanged: (String? text) {
    //                             if (text!.isEmpty || text.runes.length > 200) {
    //                               _chatsController.setShowSendButton = false;
    //                             } else if (text.isNotEmpty ||
    //                                 text.length == 1 ||
    //                                 EmojiUtil.hasOnlyEmojis(text)) {
    //                               _chatsController.setShowSendButton = true;
    //                             }
    //                           },
    //                         ),
    //                         Obx(() {
    //                           return _chatsController.getShowSendButton
    //                               ? CustomCirclerBtn(
    //                                   imgName: BrandImages.kIconSendIcon,
    //                                   onPressed: () {
    //                                     _chatsController.submitChat(
    //                                         peerId: selectedPsychologist.uid);
    //                                     print(
    //                                         "Psychologist id: ${selectedPsychologist.uid}");
    //                                   },
    //                                   redus: 19.5,
    //                                   bagroundRadius: 20.0,
    //                                   imgHeight: 22.5,
    //                                   imgWidth: 16.88,
    //                                   padding: const EdgeInsets.all(0.0),
    //                                 )
    //                               : GestureDetector(
    //                                 onTap: () {

    //                                   giphyGetWrapper.getGif('', context);

    //                                 },
    //                                 child: Image.asset(
    //                                     'assets/images/${BrandImages.kIconMic}',
    //                                     height: 22.5,
    //                                     width: 16.88,
    //                                   ),
    //                               );
    //                         })
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // return _chatsController.conversationList.length == 0 ? getWelcomeChannelMessage() : ListView.builder(

  Widget buildChatsWithDates() {
    return Container(
      height: MediaQuery.of(context).size.height -
          (_chatsController.getShowSendButton ? 283 : 208.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        DateTime? lastMessageDate;
        int? nextMessageTs;
        return ListView.builder(
          itemCount: _chatsController.conversationList.length,
          itemBuilder: (context, index) {
            if (index == _chatsController.conversationList.length) {
              return getWelcomeChannelMessage();
            }

            var message = _chatsController.conversationList[index];

            if (index - 1 >= 0) {
              lastMessageDate = DateTime.fromMillisecondsSinceEpoch(int.parse(
                  _chatsController.conversationList[index - 1].timestamp));
            }

            if (index + 1 < _chatsController.conversationList.length) {
              nextMessageTs = int.parse(
                  _chatsController.conversationList[index + 1].timestamp);
            } else {
              nextMessageTs = null;
            }

            return getMessageItem(
                message: message,
                lastMessageDate: lastMessageDate,
                nextMessageTs: nextMessageTs);
          },
        );
      }),
    );
  }

  void showSendFilesAction(BuildContext mainContext) {
    showCupertinoModalPopup<void>(
      context: mainContext,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                _chatsController.sendDocuments(
                  peerId: selectedPsychologist.uid,
                  type: TypeMessage.IMAGE,
                  context: mainContext,
                );
                Navigator.pop(context);
              },
              child: ChatActionBtn(
                icon: Icons.photo_library_outlined,
                btnText: CustomText.kmentalPhotoIcon,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _chatsController.sendDocuments(
                  peerId: selectedPsychologist.uid,
                  type: TypeMessage.VIDEO,
                  context: mainContext,
                );
                Navigator.pop(context);
              },
              child: ChatActionBtn(
                icon: Icons.video_collection,
                btnText: CustomText.kmentalVideoIcon,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                _chatsController.sendDocuments(
                  peerId: selectedPsychologist.uid,
                  type: TypeMessage.FILE,
                  context:
                      mainContext, // this will prevent the widget from throwing an error that the context is null
                );
                Navigator.pop(context);
              },
              child: ChatActionBtn(
                icon: Icons.file_open_outlined,
                btnText: CustomText.kmentalDocumentIcon,
              ),
            ),
            CupertinoActionSheetAction(
              /// This parameter indicates the action would perform
              /// a destructive action such as delete or exit and turns
              /// the action's text color to red.
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            )
          ],
        ),
      ),
    );
  }

  Widget getMessageItem(
      {required MessageChat message,
      DateTime? lastMessageDate,
      int? nextMessageTs}) {
    var currentMessageDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp));
    var isSameDate = lastMessageDate != null &&
        lastMessageDate.isSameDate(currentMessageDate);
    return Column(
      children: [
        if (!isSameDate) ...[
          Container(
            margin: EdgeInsets.only(
              top: 15.0,
              bottom: 15.0,
            ),
            child: Text(
              '${TimFormatter.formatShortDate(currentMessageDate)}th',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13.0,
                color: AppColors.mentalBarUnselected,
              ),
            ),
          ),
        ],
        ChatBubble(message: message, isMe: checkIsMe(fromId: message.idFrom)),
      ],
    );
  }

  Widget getWelcomeChannelMessage() {
    return Transform.translate(
      offset: Offset(0.0, MediaQuery.of(context).size.height * 0.3),
      child: Column(
        children: [
          Text(
            'No chat here yet! Start chatting with your psychologist.',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
                color: AppColors.mentalBarUnselected),
          ),
          Icon(
            Icons.tag_faces_rounded,
            color: AppColors.mentalBarUnselected,
            size: 60.0,
          ),
        ],
      ),
    );
  }

  bool checkIsMe({required String fromId}) {
    return fromId == _chatsController.currentUserId as String;
  }

  // Widget buildGiphyPicker() {
  //   return GiphyGetWrapper(
  //     giphy_api_key: dotenv.env['GLIPHY']!,
  //     builder: (stream, giphyGetWrapper) {
  //       stream.listen((gif) {
  //           setState(() {
  //             currentGif = gif;
  //           });
  //         });

  //       return Container();
  //     },
  //   );
  // }
}
