import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart' as audio_player;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:intl/intl.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/chats/model/message_chat.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/home/application/home_controller.dart';
import 'package:mental_health_care_app/uis/firestore_constants.dart';
import 'package:mental_health_care_app/utils/custom_exceptions.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:wakelock/wakelock.dart';

final kTheSource = AudioSource.microphone;

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
  FlutterSoundRecorder? _mRecorder;
  StreamSubscription? _recorderSubscription;
  Codec _codec = Codec.aacMP4;
  String _mPath = 'mental_audio_file.mp4';
  RxBool _mRecorderIsInited = false.obs;
  RxString recorderDuration = '00:00'.obs;
  RxBool mPauseRecorder = false.obs;
  RxString _mRecordedAudioPath = ''.obs;
  int realAudioDuration = 0;
  List<double> waveformPercentages = <double>[];
  final player = audio_player.AudioPlayer();
  RxInt selectedAudioCurrentPosition = 0.obs;
  RxBool isCurrentAudioPlaying = false.obs;
  RxInt selectedAudioDuration = 0.obs;
  Rx<MessageChat> selectedAudioMessage = MessageChat.defaultMessage().obs;

  @override
  void onReady() {
    super.onReady();
    conversationList.bindStream(getAllMessages());
    _mRecorder = FlutterSoundRecorder();
    openTheRecorder()
        .then((value) => _mRecorderIsInited.value = true)
        .catchError((error) {
      _mRecorderIsInited.value = false;
      print(error);
    });
  }

  @override
  void onClose() {
    super.onClose();
    conversationList.clear();
    searchController.dispose();
    chatFieldController.dispose();
    _mRecorder?.stopRecorder();
    _recorderSubscription?.cancel();
    player.stop();
    player.dispose();
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
        //.limit(30) // don't add limit to the stream
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return MessageChat.fromMap(doc.data(), uid: doc.id);
            }).toList());
  }

  void submitAudioChat({
    required String peerId,
    required int type,
    required BuildContext context,
  }) async {
    try {
      final audioUrl = await _mRecorder!.stopRecorder();
      final audioFile = File(audioUrl!);
      final waveFile =
          File(p.join((await getTemporaryDirectory()).path, 'waveform.wave'));
      final progressWaveStream = JustWaveform.extract(
        audioInFile: audioFile,
        waveOutFile: waveFile,
      );

      progressWaveStream.listen(
        (progress) {
          if (progress.waveform != null) {
            print('Waveform extracted');
            print('Waveform: ${progress.waveform!.data}');
            print('Waveform length: ${progress.waveform!.data.length}');
            realAudioDuration = progress.waveform!.duration.inMilliseconds;
            waveformPercentages =
                progress.waveform!.data.map((i) => i.toDouble()).toList();
            // showAudio.value = true;
          }
        },
        onDone: () async {
          print('audio file is $audioFile');

          if (realAudioDuration != 0 && waveformPercentages.length != 0) {
            await uploadFiles(
              imagePath: audioFile.path,
              imageName: "${p.basename(audioFile.path)}${Uuid().v1()}",
              folder: FirestoreConstants.pathChatAudios,
            ).then(
              (value) {
                final groupChatId = "${_auth.currentUser!.uid}-$peerId";
                print("Uploaded Audio file");

                sendMessage(
                  content: value[0],
                  type: type,
                  groupChatId: groupChatId,
                  currentUserId: currentUserId,
                  peerId: peerId,
                  documentName: value[1],
                  audioDuration: realAudioDuration,
                  waveformPercentages: waveformPercentages,
                );
              },
            ).catchError((e) {
              print(e);
              showError(context: context, e: e);
            });
          }
        },
      );
    } catch (e) {
      print(e);
      showError(context: context, e: e);
    }
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
    int? audioDuration,
    List<double>? waveformPercentages,
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
      audioDuration: audioDuration ?? 0,
      audioWaveform: waveformPercentages ?? [],
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
    return [imgUrl, p.basename(imagePath)];
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

  /// <--- The recording section --->

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'mental_audio_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited.value = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited.value = true;
    update();
  }

  void closeRecording() {
    isRecording.value = false;
  }

  void deleteRecording() async {
    await _mRecorder!.stopRecorder().then((value) {
      print('Recording stopped, here is the path: ${value}');
      _mRecordedAudioPath.value = value!;
      mPauseRecorder.value = false;
      update();
    });
    Wakelock.disable();
  }

  // Recording sections for voice notes messages
  // start recording
  void startRecording() async {
    try {
      await _mRecorder!.startRecorder(
          codec: _codec,
          toFile: _mPath,
          audioSource: kTheSource,
          sampleRate: 44100,
          bitRate: 96000);

      _mRecorder!.logger.d("<-- Started recording -->");

      _recorderSubscription = _mRecorder!.onProgress!.listen((progress) {
        var date = DateTime.fromMillisecondsSinceEpoch(
          progress.duration.inMilliseconds,
        );
        print("The date is: ${date.toString()}");
        var text = DateFormat('mm:ss').format(date);
        recorderDuration.value = text;
        _mRecorder!.logger.d('startRecorder from me here 2');
      });

      _mRecorder!.setSubscriptionDuration(Duration(milliseconds: 60));

      isRecording.value = true;
      mPauseRecorder.value = false;
      Wakelock.enabled;
    } catch (e) {
      print(e);
    }
  }

  resume() async {
    await _mRecorder!.resumeRecorder();
    mPauseRecorder.value = false;
    Wakelock.enabled;
    update();
  }

  pause() async {
    await _mRecorder!.pauseRecorder();
    mPauseRecorder.value = true;
    Wakelock.disable;
    update();
  }

  // Audio player section
  void playAudioChat({required String url}) async {
    await player.stop();
    isCurrentAudioPlaying.value = false;
    await player.play(audio_player.UrlSource(url));

    print('Playing audio chat');

    player.onPlayerComplete.listen((event) {
      print('Audio chat completed');
      isCurrentAudioPlaying.value = false;
    });

    player.onDurationChanged.listen((event) {
      //print('Audio chat duration changed');
      selectedAudioDuration.value = event.inMilliseconds;
    });

    player.onPositionChanged.listen((position) {
      selectedAudioCurrentPosition.value = position.inMilliseconds;
      //print('The position is: ${position.inMilliseconds}');
      update();
    });

    isCurrentAudioPlaying.value = true;
  }

  void pauseAudioPlayer() async {
    await player.pause();
    isCurrentAudioPlaying.value = false;
    update();
  }

  void playAudio({required String url}) async {
    if (selectedAudioCurrentPosition.value == 0) {
      playAudioChat(url: url);
    } else if (selectedAudioCurrentPosition.value != 0 &&
        isCurrentAudioPlaying.value == true) {
      pauseAudioPlayer();
    } else {
      await player.resume();
      isCurrentAudioPlaying.value = true;
    }
  }

  void seekPlayerPosition({required Offset localPosition, required double maxWidth, required int duration }) async {
    print("Tapped scrubber at ${localPosition.dx}");
    var position = localPosition.dx < 0 ? 0 : (localPosition.dx > maxWidth ? maxWidth : localPosition.dx);
    var calculatePosition = position / maxWidth * duration;
    await player.seek(Duration(milliseconds: calculatePosition.toInt()));
  }
  
  // help to set audio message that we currently tapped on to play.
  void setMessageToPlay({required MessageChat messageChat}) async {
    selectedAudioMessage.value = messageChat;
    print("Got called");
  }

  // check which audio bubble to play.
  bool isAudioMessageToPlay({required MessageChat messageChat}) {
    if (selectedAudioMessage.value.messageUid != '') {
      return selectedAudioMessage.value.timestamp == messageChat.timestamp;
    }else {
      return false;
    }
  }
}
