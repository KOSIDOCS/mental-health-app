import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_care_app/chats/model/message_chat.dart';
import 'package:mental_health_care_app/chats/presentation/chat_document_preview.dart';
import 'package:mental_health_care_app/chats/presentation/chat_video_viewer.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/spacing.dart';
import 'package:mental_health_care_app/utils/time_formatter.dart';
import 'package:path/path.dart';
import 'package:cached_video_preview/cached_video_preview.dart';

class ChatBubble extends StatelessWidget {
  final MessageChat message;
  final bool isMe;
  const ChatBubble({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: getChatBubbleTemplate(messageType: message.type, context: context),
    );
  }

  Widget showImageBubble(
      {required String imageUrl, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        final imageProvider = Image.network(imageUrl).image;
        showImageViewer(context, imageProvider, onViewerDismissed: () {
          print("dismissed");
        });
      },
      child: Container(
        width: 250.0,
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? AppColors.mentalBrandColor2 : AppColors.mentalPureWhite,
          borderRadius: customBorderRadius,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: customBorderRadius,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 200.0,
                width: 250.0,
              ),
            ),
            Transform.translate(
              offset: Offset(-10.0, 170.0),
              child: Row(
                children: [
                  Spacer(),
                  SizedBox(width: 5.0),
                  Text(
                    TimFormatter.formatChatTime(int.parse(message.timestamp)),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: AppColors.mentalPureWhite,
                        ),
                  ),
                  CustomIcon(isRead: message.readMessage,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showDocument(
      {required String imageUrl,
      required BuildContext context,
      required String fileName}) {
    return GestureDetector(
      onTap: () async {
        print("tapped: $imageUrl");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDocumentPreview(
            documentUrl: imageUrl,
          );
        }));
      },
      child: Container(
        width: 250.0,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? AppColors.mentalBrandColor2 : AppColors.mentalPureWhite,
          borderRadius: customBorderRadius,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  color: AppColors.mentalBrandColor,
                  size: 30.0,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  basename(fileName).split('.').first,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: AppColors.mentalChatTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: Offset(-10.0, 20.0),
              child: Row(
                children: [
                  Spacer(),
                  SizedBox(width: 5.0),
                  Text(
                    TimFormatter.formatChatTime(int.parse(message.timestamp)),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: AppColors.mentalBarUnselected,
                        ),
                  ),
                  CustomIcon(isRead: message.readMessage,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showVideoBubble(
      {required String imageUrl, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChatVideoViewer(
                  videoUrl: imageUrl,
                );
              },
            ));
      },
      child: Container(
        width: 250.0,
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? AppColors.mentalBrandColor2 : AppColors.mentalPureWhite,
          borderRadius: customBorderRadius,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: customBorderRadius,
              child: CachedVideoPreviewWidget(
                path: imageUrl,
                type: SourceType.remote,
                httpHeaders: const <String, String>{},
                remoteImageBuilder: (BuildContext context, url) =>
                    Image.network(
                  url,
                  fit: BoxFit.cover,
                  height: 200.0,
                  width: 250.0,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0.0, 50.0),
              child: Center(
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  size: 50.0,
                  color: AppColors.mentalPureWhite,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-10.0, 110.0),
              child: Row(
                children: [
                  Spacer(),
                  SizedBox(width: 5.0),
                  Text(
                    TimFormatter.formatChatTime(int.parse(message.timestamp)),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: AppColors.mentalPureWhite,
                        ),
                  ),
                  CustomIcon(isRead: message.readMessage,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget showGiphyBubble(
      {required String imageUrl, required BuildContext context}) {
    return Container(
      width: message.gifWidth,
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: isMe ? AppColors.mentalBrandColor2 : AppColors.mentalPureWhite,
        borderRadius: customBorderRadius,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: customBorderRadius,
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              // height: message.gifHeight,
              height: 200.0,
              width: message.gifWidth,
            ),
          ),
          Transform.translate(
            offset: Offset(-10.0, 170.0),
            child: Row(
              children: [
                Spacer(),
                SizedBox(width: 5.0),
                Text(
                  TimFormatter.formatChatTime(int.parse(message.timestamp)),
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0,
                        color: AppColors.mentalPureWhite,
                      ),
                ),
                CustomIcon(isRead: message.readMessage,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getChatBubbleTemplate(
      {required int messageType, required BuildContext context}) {
    switch (messageType) {
      case TypeMessage.IMAGE:
        return showImageBubble(imageUrl: message.content, context: context);

      case TypeMessage.FILE:
        return showDocument(
            imageUrl: message.content,
            context: context,
            fileName: message.documentName);
      case TypeMessage.VIDEO:
        return showVideoBubble(
          imageUrl: message.content,
          context: context,
        );
      case TypeMessage.GIPHY:
        return showGiphyBubble(
          imageUrl: message.content,
          context: context,
        );  
      default:
        return Container(
          width: 200.0,
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color:
                isMe ? AppColors.mentalBrandColor2 : AppColors.mentalPureWhite,
            borderRadius: customBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
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
                    TimFormatter.formatChatTime(int.parse(message.timestamp)),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: AppColors.mentalBarUnselected,
                        ),
                  ),
                  CustomIcon(isRead: message.readMessage,),
                ],
              )
            ],
          ),
        );
    }
  }
}
