import 'package:mental_health_care_app/chats/model/message_chat.dart';
import 'package:mental_health_care_app/home/model/psychologist_model.dart';

class ChatGroupModel {
  final PsychologistModel user;
  final MessageChat lastChat;

  ChatGroupModel({required this.user, required this.lastChat});

  factory ChatGroupModel.fromMap({required PsychologistModel user, required MessageChat lastChat}) {
    return ChatGroupModel(
      user: user,
      lastChat: lastChat,
    );
  }
}