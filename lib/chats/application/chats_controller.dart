import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/chats/model/message_chat.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/home/application/home_controller.dart';
import 'package:mental_health_care_app/uis/firestore_constants.dart';
import 'package:mental_health_care_app/utils/custom_exceptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ChatsController extends GetxController {
  TextEditingController searchController = TextEditingController();
  TextEditingController chatFieldController = TextEditingController();
  final AuthController authController = Get.find();
  final HomeController homeController = Get.find();
  final FirebaseFirestore _firebaseFirestoredb = Get.find();
  final FirebaseAuth _auth = Get.find();
  //final FirebaseStorage _storage = Get.find();
  final RxBool _showSendButton = false.obs;
  set setShowSendButton(bool value) => _showSendButton.value = value;
  get getShowSendButton => _showSendButton.value;
  get currentUserId => _auth.currentUser?.uid;

  RxList<MessageChat> conversationList = <MessageChat>[].obs;

  //Audio recording section here
  final LocalFileSystem localFileSystem = LocalFileSystem();
  final RxBool isRecording = false.obs;
  FlutterAudioRecorder2? _recorder;
  Rx<Recording?> _current = Recording().obs;
  Rx<RecordingStatus> _currentStatus = RecordingStatus.Unset.obs;

  @override
  void onReady() {
    super.onReady();
    conversationList.bindStream(getAllMessages());
    _init();
  }

  Stream<List<MessageChat>> getAllMessages() {
    print('I was called here for messages');
    final groupChatId =
        "${_auth.currentUser!.uid}-${homeController.openChatWithId.value}";
    return _firebaseFirestoredb
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: false)
        // .limit(30)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return MessageChat.fromMap(doc.data(), uid: doc.id);
            }).toList());
  }

  void submitChat({required String peerId}) {
    if (chatFieldController.text.isNotEmpty) {
      final groupChatId = "${_auth.currentUser!.uid}-$peerId";
      sendMessage(
        content: chatFieldController.text,
        type: TypeMessage.TEXT,
        groupChatId: groupChatId,
        currentUserId: _auth.currentUser!.uid,
        peerId: peerId,
      );
      chatFieldController.clear();
      _showSendButton.value = false;
    }
  }

  void sendDocuments({
    required String peerId,
    required int type,
    required BuildContext context,
  }) async {
    List<String> pickFilesType = ['jpg', 'png', 'jpeg'];
    FileType fileType = FileType.custom;
    String storageLocation = FirestoreConstants.pathChatImages;

    if (type == TypeMessage.FILE) {
      fileType = FileType.custom;
      storageLocation = FirestoreConstants.pathChatDocuments;
      pickFilesType = ['pdf'];
    } else if (type == TypeMessage.VIDEO) {
      fileType = FileType.video;
      storageLocation = FirestoreConstants.pathChatVideos;
      pickFilesType = [];
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: pickFilesType,
    );

    if (result != null) {
      print("Here is our Image name: ${result.files.first.name}");
      await uploadFiles(
        imagePath: result.files.first.path!,
        imageName: "${result.files.first.name}${Uuid().v1()}",
        folder: storageLocation,
      ).then(
        (value) {
          final groupChatId = "${_auth.currentUser!.uid}-$peerId";

          sendMessage(
            content: value[0],
            type: type,
            groupChatId: groupChatId,
            currentUserId: currentUserId,
            peerId: peerId,
            documentName: value[1],
          );
        },
      ).catchError((e) {
        print(e);
        // Get.snackbar(
        //   "Issue uploading Image", // title
        //   e.toString(), // message
        //   icon: Icon(Icons.alarm),
        //   shouldIconPulse: true,
        //   onTap: (value) {},
        //   barBlur: 20,
        //   isDismissible: true,
        //   duration: Duration(seconds: 3),
        //   backgroundColor:
        // );
        showError(context: context, e: e);
      });
    }
  }

  void sendGiphy({
    required String peerId,
    required int type,
    required BuildContext context,
    required GiphyGif giphyGif,
  }) async {
    final groupChatId = "${_auth.currentUser!.uid}-$peerId";

    sendMessage(
      content: giphyGif.images!.fixedWidth.url,
      type: type,
      groupChatId: groupChatId,
      currentUserId: currentUserId,
      peerId: peerId,
      documentName: '',
      gifHeight: double.parse(giphyGif.images!.fixedWidth.height),
      gifWidth: double.parse(giphyGif.images!.fixedWidth.width),
    );
  }

  void sendMessage({
    required String content,
    required int type,
    required String groupChatId,
    required String currentUserId,
    required String peerId,
    String? documentName,
    double? gifHeight,
    double? gifWidth,
  }) {
    DocumentReference documentReference = _firebaseFirestoredb
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      content: content,
      type: type,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      idFrom: currentUserId,
      idTo: peerId,
      messageUid: DateTime.now().millisecondsSinceEpoch.toString(),
      readMessage: false,
      documentName: documentName ?? '',
      gifHeight: gifHeight ?? 0.0,
      gifWidth: gifWidth ?? 0.0,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    }).then((value) {
      print("The conversation has been sent");

      var conversationlist = authController.firestoreUser.value;

      if (conversationlist?.conversations.contains(peerId) == false) {
        print('The conversation is not in the list');
        _firebaseFirestoredb
            .collection(FirestoreConstants.pathUserCollection)
            .doc(_auth.currentUser!.uid)
            .update({
          'conversations': FieldValue.arrayUnion([peerId])
        });

        _firebaseFirestoredb
            .collection(FirestoreConstants.pathPsychologists)
            .doc(peerId)
            .update({
          'conversations': FieldValue.arrayUnion([_auth.currentUser!.uid])
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  Future<List<String>> uploadFiles({
    required String imagePath,
    required String imageName,
    required String folder,
  }) async {
    File imgToUpload = File(imagePath);

    int filesize = await imgToUpload.length();

    if (filesize > 9000000) {
      // 8000000 bytes = 8MB
      throw FileSizeException(CustomErrorText.invalidFileSize);
    }

    Reference imgRef;
    String imgUrl = '';
    imgRef = authController.storage.ref().child('$folder/$imageName');
    await imgRef.putFile(imgToUpload).whenComplete(() async {
      await imgRef.getDownloadURL().then((url) {
        imgUrl = url;
        if (kDebugMode) {
          print('Image uploaded to firebase storage: $url');
        }
      });
    });
    return [imgUrl, basename(imagePath)];
  }

  void showError({required BuildContext context, dynamic e}) {
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Text(
        e.toString().split(':').last,
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: 14.0,
            ),
      ),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void closeRecording() {
    // _recordingController.stop();
    // _recordingController = null;
    isRecording.value = false;
  }

  stop() async {
    var result = await _recorder!.stop();
    print("Stop recording: ${result!.path}");
    print("Stop recording: ${result.duration}");
    File file = localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    _current.value = result;
    _currentStatus.value = _current.value!.status!;
    _init();
  }

  // Recording sections for voice notes messages
  void _init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;

      if (hasPermission) {
        String customPath = '/mental_audio_recorder_';
        Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);

        await _recorder!.initialized;
        // after initialization
        var current = await _recorder!.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        _current.value = current;
        _currentStatus.value = current!.status!;
        print(_currentStatus);
      } else {
        Get.snackbar(
          "Issue with mic acces", // title
          'You must accept permissions', // message
          icon: Icon(Icons.mic),
          shouldIconPulse: true,
          onTap: (value) {},
          barBlur: 20,
          isDismissible: true,
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.mentalRed,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Issue with voice recording", // title
        e.toString(), // message
        icon: Icon(Icons.mic),
        shouldIconPulse: true,
        onTap: (value) {},
        barBlur: 20,
        isDismissible: true,
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.mentalRed,
      );
    }
  }

  // start recording
  void startRecording() async {
    try {
      await _recorder!.start();
      isRecording.value = true;
      var recording = await _recorder!.current(channel: 0);
      _current.value = recording;

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder!.current(channel: 0);
        // print(current.status);
        _current.value = current;
        _currentStatus.value = _current.value!.status!;
      });

      // if (_current.value?.status == RecordingStatus.Recording) {
      //   isRecording.value = true;
      // }

    } catch (e) {
      print(e);
    }
  }

  String getDuration() {
    if (_current.value == null) {
      return '00:00';
    }
    return _current.value!.duration.toString().split('.').first;
  }

  resume() async {
    await _recorder!.resume();
    update();
  }

  pause() async {
    await _recorder!.pause();
    update();
  }

  // stop() async {
  //   var result = await _recorder!.stop();
  //   print("Stop recording: ${result!.path}");
  //   print("Stop recording: ${result.duration}");
  //   File file = localFileSystem.file(result.path);
  //   print("File length: ${await file.length()}");
  //     _current.value = result;
  //     _currentStatus.value = _current.value!.status!;
  // }
}
