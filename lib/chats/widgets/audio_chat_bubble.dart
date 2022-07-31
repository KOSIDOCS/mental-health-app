import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/chats/model/message_chat.dart';
import 'package:mental_health_care_app/chats/widgets/wave/rectangle_waveform/rectangle_waveform.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/spacing.dart';
import 'package:mental_health_care_app/utils/time_formatter.dart';

class AudioChatBubble extends StatelessWidget {
  final MessageChat message;
  final bool isMe;
  final int index;
  final dynamic controller;
  const AudioChatBubble({Key? key, required this.message, required this.isMe, required this.index, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    controller.setMessageToPlay(messageChat: message);
                    controller.playAudio(url: message.content);
                  },
                  child: Icon(
                    controller.isAudioMessageToPlay(messageChat: message) && controller.isCurrentAudioPlaying.value // fix this
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: AppColors.mentalBrandColor,
                    size: 30.0,
                  ),
                );
              }),
              SizedBox(
                width: 5.0,
              ),
              Obx(() {
                return Stack(
                  children: [
                    Positioned.fill(
                      top: 18.0,
                      child: GestureDetector(
                        child: RectangleWaveform(
                          maxDuration: Duration(
                            milliseconds: message.audioDuration,
                          ),
                          elapsedDuration: Duration(
                            milliseconds: controller.isAudioMessageToPlay(messageChat: message) ? controller
                                .selectedAudioCurrentPosition.value : 0,
                          ),
                          samples: message.audioWaveform,
                          height: 26,
                          // width: MediaQuery.of(context).size.width,
                          width: 180,
                          absolute: true,
                          borderWidth: 2.0,
                          activeColor: AppColors.mentalBrandLightColor,
                          inactiveColor: AppColors.mentalBrandColor,
                          inactiveBorderColor: AppColors.mentalBrandColor,
                          activeBorderColor: AppColors.mentalBrandLightColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (update) {
                        controller.seekPlayerPosition(
                        localPosition: update.localPosition,
                        maxWidth: 180.0,
                        duration: message.audioDuration,
                      );
                      },
                      onHorizontalDragUpdate: (update) {
                        controller.seekPlayerPosition(
                        localPosition: update.localPosition,
                        maxWidth: 180.0,
                        duration: message.audioDuration,
                      );
                      },
                      child: Container(
                        height: 26.0,
                        width: 180.0,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                );
              }),
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
                CustomIcon(
                  isRead: message.readMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}