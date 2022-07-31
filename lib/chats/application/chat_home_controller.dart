import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/chats/model/chat_group_model.dart';
import 'package:mental_health_care_app/chats/model/message_chat.dart';
import 'package:mental_health_care_app/home/application/home_controller.dart';
import 'package:mental_health_care_app/home/model/psychologist_model.dart';
import 'package:mental_health_care_app/uis/firestore_constants.dart';

class ChatHomeController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final AuthController authController = Get.find();
  final HomeController homeController = Get.find();
  final FirebaseFirestore _firebaseFirestoredb = Get.find();
  final FirebaseAuth _auth = Get.find();
  //final RxList<ChatGroupModel> _chatGroups = <ChatGroupModel>[].obs;
  RxList<ChatGroupModel> conversationUsers = <ChatGroupModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    getConversations();
  }

  void getConversations() {
    final conversations = authController.firestoreUser.value!.conversations;

    conversations.forEach((conversation) {
      print(conversation);
      homeController.psychologists.forEach((psychologist) async {
        print(psychologist.name);
        if (conversation == psychologist.uid) {
          var lastMessage = await getLastMessage(
              groupChatId: "${_auth.currentUser!.uid}-${psychologist.uid}");
          var unreadMessagesCount = await getUnreadMessagesCount(
              groupChatId: "${_auth.currentUser!.uid}-${psychologist.uid}");
          conversationUsers.add(
            ChatGroupModel(
              user: psychologist,
              lastChat: lastMessage,
              unreadMessagesCount: unreadMessagesCount,
            ),
          );
        }
      });
    });
  }

  Future<MessageChat> getLastMessage({required String groupChatId}) {
    return _firebaseFirestoredb
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((snapshot) {
      return MessageChat.fromMap(snapshot.docs.first.data(),
          uid: snapshot.docs.first.id);
    });
  }

  Future<int> getUnreadMessagesCount({required String groupChatId}) {
    return _firebaseFirestoredb
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .where('readMessage', isEqualTo: false)
        .get()
        .then((snapshot) {
      return snapshot.docs.length;
    });
  }

  void openGroupChat({required PsychologistModel user}) {
    homeController.openChatWithId.value = user.uid;
    Get.toNamed('/chats/chat-room', arguments: user);
  }

  void searchUsers() {
    if (searchController.text.isEmpty) {
      conversationUsers.value = [];
      getConversations();
    } else {
      conversationUsers.value = conversationUsers.where((element) {
        return element.user.name
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }).toList();
    }
  }
}
