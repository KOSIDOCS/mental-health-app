import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart' as audio_player;
import 'package:cloud_firestore/cloud_firestore.dart';
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
  // final LocalFileSystem localFileSystem = LocalFileSystem();
  final RxBool isRecording = false.obs;
  // FlutterAudioRecorder2? _recorder;
  // Rx<Recording?> _current = Recording().obs;
  // Rx<RecordingStatus> _currentStatus = RecordingStatus.Unset.obs;

  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer;
  FlutterSoundRecorder? _mRecorder;
  bool _mPlayerIsInited = false;
  RxBool _mRecorderIsInited = false.obs;
  RxString recorderDuration = '00:00'.obs;
  bool _mplaybackReady = false;
  final kTheSource = AudioSource.microphone;
  StreamSubscription? _recorderSubscription;
  StreamSubscription? _playerSubscription;
  final Stopwatch _stopwatch = Stopwatch();
  RxBool showAudio = false.obs;

  //for drawing sounds samples
  // max decibels heard while monitoring recording
  static double maxDecibels = 10.0;

  // How many bars should be drawn?
  static final int BARS = 5;

  // List holding decibel level for bars
  List<double> soundSamples =
      List.generate(BARS, (index) => 0.0, growable: false);

  // Index for next sound sample - keeps a rolling window of sound samples
  final ndxBars = 0.obs;

  // waveform for current sound sample
  RxList<double> waveformPercentages = <double>[].obs;
  RxInt realAudioDuration = 0.obs;
  RxInt audioPlayerCurrentPosition = 0.obs;
  RxString _currentRecordingPath = ''.obs;

  // new player
  final player = audio_player.AudioPlayer();

  @override
  void onReady() async {
    super.onReady();
    conversationList.bindStream(getAllMessages());
    //_init();
    _mPlayer = FlutterSoundPlayer();
    _mRecorder = FlutterSoundRecorder();
    await openTheRecorder().then((value) {
      _mRecorderIsInited.value = true;
    }).catchError((error) {
      _mRecorderIsInited.value = false;
      print(error.toString());
    });

    await _mPlayer!.openPlayer().then((value) {
      _mPlayerIsInited = true;
    });
  }

  @override
  void onClose() {
    super.onClose();
    _mRecorder?.closeRecorder();
    _mRecorder = null;
    _mPlayer?.closePlayer();
    _mRecorder = null;
    searchController.dispose();
    chatFieldController.dispose();
    _recorderSubscription?.cancel();
    _playerSubscription?.cancel();
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
        .limit(30)
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

  void closeRecording() {
    // _recordingController.stop();
    // _recordingController = null;
    isRecording.value = false;
  }

  stop() async {
    await _mRecorder!.stopRecorder().then((value) {
      _mplaybackReady = true;
      update();
    });

    // var result = await _recorder!.stop();
    // print("Stop recording: ${result!.path}");
    // print("Stop recording: ${result.duration}");
    // File file = localFileSystem.file(result.path);
    // print("File length: ${await file.length()}");
    //   _current.value = result;
    //   _currentStatus.value = _current.value!.status!;
    //   _init();
  }

  // Recording sections for voice notes messages
//   void _init() async {
//     try {
//       bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;

//       if (hasPermission) {
//         String customPath = '/mental_audio_recorder_';
//         Directory appDocDirectory;
// //        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
//         if (Platform.isIOS) {
//           appDocDirectory = await getApplicationDocumentsDirectory();
//         } else {
//           appDocDirectory = (await getExternalStorageDirectory())!;
//         }

//         // can add extension like ".mp4" ".wav" ".m4a" ".aac"
//         customPath = appDocDirectory.path +
//             customPath +
//             DateTime.now().millisecondsSinceEpoch.toString();

//         // .wav <---> AudioFormat.WAV
//         // .mp4 .m4a .aac <---> AudioFormat.AAC
//         // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
//         _recorder =
//             FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);

//         await _recorder!.initialized;
//         // after initialization
//         var current = await _recorder!.current(channel: 0);
//         print(current);
//         // should be "Initialized", if all working fine
//           _current.value = current;
//           _currentStatus.value = current!.status!;
//           print(_currentStatus);
//       } else {
//         Get.snackbar(
//           "Issue with mic acces", // title
//           'You must accept permissions', // message
//           icon: Icon(Icons.mic),
//           shouldIconPulse: true,
//           onTap: (value) {},
//           barBlur: 20,
//           isDismissible: true,
//           duration: Duration(seconds: 2),
//           backgroundColor: AppColors.mentalRed,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//           "Issue with voice recording", // title
//           e.toString(), // message
//           icon: Icon(Icons.mic),
//           shouldIconPulse: true,
//           onTap: (value) {},
//           barBlur: 20,
//           isDismissible: true,
//           duration: Duration(seconds: 2),
//           backgroundColor: AppColors.mentalRed,
//         );
//     }
//   }

  // start recording
  void startRecording() async {
    // await _mRecorder!.setSubscriptionDuration(
    //   Duration(milliseconds: 100),
    // );

    await _mRecorder!.startRecorder(
        toFile: _mPath,
        codec: _codec,
        audioSource: kTheSource,
        // bitRate: 8000, // remove this and it's working.
        // numChannels: 1,
        sampleRate: 44100,
        bitRate: 96000);

    _mRecorder!.logger.d('startRecorder from me here');

    // Reset recording data
    soundSamples = List.generate(BARS, (index) => 0.0, growable: false);
    ndxBars.value = 0;
    maxDecibels = 10.0;

    _recorderSubscription = _mRecorder?.onProgress?.listen((progress) {
      update();
      _mRecorder!.logger.d('startRecorder from me here 3');
      var date = DateTime.fromMillisecondsSinceEpoch(
        progress.duration.inMilliseconds,
      );
      print("The date is: ${date.toString()}");
      var text = DateFormat('mm:ss').format(date);
      // recorderDuration.value = text.substring(0, 8);
      recorderDuration.value = text;
      _mRecorder!.logger.d('startRecorder from me here 2');

      // Listen in on the audio stream so we can create a waveform of the audio
      double? decibels = progress.decibels;
      if (decibels! > maxDecibels) maxDecibels = decibels;
      soundSamples[ndxBars.value] = decibels;
      if (++ndxBars.value >= BARS) ndxBars.value = 0;
      print(text);
      update();
    });

    await _mRecorder!.setSubscriptionDuration(
      Duration(milliseconds: 60),
    );

    isRecording.value = true;

    // try {
    //   await _recorder!.start();
    //   isRecording.value = true;
    //   var recording = await _recorder!.current(channel: 0);
    //     _current.value = recording;

    //   const tick = const Duration(milliseconds: 50);
    //   new Timer.periodic(tick, (Timer t) async {
    //     if (_currentStatus == RecordingStatus.Stopped) {
    //       t.cancel();
    //     }

    //     var current = await _recorder!.current(channel: 0);
    //     // print(current.status);
    //       _current.value = current;
    //       _currentStatus.value = _current.value!.status!;
    //   });

    //   // if (_current.value?.status == RecordingStatus.Recording) {
    //   //   isRecording.value = true;
    //   // }

    // } catch (e) {
    //   print(e);
    // }
  }

  resume() async {
    await _mRecorder!.resumeRecorder();
    update();
    // await _recorder!.resume();
    // update();
  }

  pause() async {
    _mRecorder!.pauseRecorder().then((value) {
      update();
    });
    // await _recorder!.pause();
    // update();
  }

  deletVoice() {
    _mRecorder!.stopRecorder().then((value) async {
      final waveFile =
          File(p.join((await getTemporaryDirectory()).path, 'waveform.wave'));
      var len = await File(value!).length();
      //var file = File(value).;
      print("Stop recording: $value");
      print("Stop recording len: $len");
      print("Sound samples: $soundSamples");
      // A test to generate a waveform from the sound samples
      _currentRecordingPath.value = File(value).path;
      final progressStream = JustWaveform.extract(
        audioInFile: File(value),
        waveOutFile: waveFile,
        //zoom: const WaveformZoom.pixelsPerSecond(100),
      );
      progressStream.listen((waveformProgress) {
        print('Progress: %${(100 * waveformProgress.progress).toInt()}');
        if (waveformProgress.waveform != null) {
          // Use the waveform.
          print('Waveform: ${waveformProgress.waveform!.data}');
          print('Waveform length: ${waveformProgress.waveform!.data.length}');
          realAudioDuration.value =
              waveformProgress.waveform!.duration.inMilliseconds;
          waveformPercentages.value = waveformProgress.waveform!.data
              .map((i) => i.toDouble())
              .toList();
          showAudio.value = true;
        }
      });
      // showAudio.value = true;
      //_mRecorder!.closeRecorder(); //called in stopRecorder()
      //_mRecorder!.deleteRecord(fileName: _mPath);
      update();
    });
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

  // with flutter sound
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
      _mPath = 'tau_file.webm';
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

  void startTimer() {
    print("DEBUG: TIMER -> startTimer");
    isRecording.value = true;
    _stopwatch.start();
    Wakelock.enable();
  }

  Future<void> stopTimer() async {
    print("DEBUG: TIMER -> stopTimer");
    isRecording.value = false;
    _stopwatch.stop();
    await Wakelock.disable();
  }

  // void releaseRecorder() async {
  //   await Future.wait<void>([
  //     stopTimer(),
  //     _myRecorder.stopRecorder(),
  //     _myRecorder.closeRecorder(),
  //     setNonInterruptions(false),
  //     AudioPlayerHandler.initPlayRecordSession(),
  //   ]);
  //   await _inputChangeStream?.cancel();
  //   initStatus();
  // }

  // void initStatus() async {
  //   _isSending.value = false;
  //   _audioInput.value = null;
  //   _message.value = null;

  //   _messageReplies.value = null;
  //   _messageWithNotes.value = null;
  //   _isReply.value = false;
  //   _attachments.value = [];
  //   _duration.value = Duration(seconds: 0);
  //   _stopwatch.reset();
  // }

  // String getTimerCount() {
  //   var totalSeconds = _duration.value.inSeconds;
  //   var minutes = totalSeconds ~/ 60.0;
  //   var seconds = totalSeconds - minutes * 60;
  //   if (isRecording() || _duration.value.inMilliseconds > 0) {
  //     return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  //   } else {
  //     return "--:--";
  //   }
  // }

  // Player section
  void play() async {
    // assert(_mPlayerIsInited &&
    //     _mplaybackReady &&
    //     _mRecorder!.isStopped &&
    //     _mPlayer!.isStopped);
    print("The real audio duration: ${realAudioDuration.value}");
    await _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            sampleRate: 44100,
            codec: _codec,
            whenFinished: () {
              update();
            })
        .then((value) {
      update();
    });

    _playerSubscription = _mPlayer?.onProgress?.listen((progress) {
      update();
      print('Progress: ${(progress.position.inMilliseconds)}');
      audioPlayerCurrentPosition.value = progress.position.inMilliseconds * 2;
      print("The current position: ${audioPlayerCurrentPosition.value}");
      update();
    });

    await _mPlayer!.setSubscriptionDuration(Duration(seconds: 10));
    update();
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      update();
    });
  }

  void secondPlayer() async {
    var testFile = File(_currentRecordingPath.value);
    print("The main file path: ${testFile.path}");
    print("The main file length: ${await testFile.length()}");
    print("The main file exists: ${await testFile.exists()}");
    await player.play(audio_player.DeviceFileSource(testFile.path));

    player.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      realAudioDuration.value = d.inMilliseconds;
      update();
    });

    player.onPositionChanged.listen((Duration duration) {
      print('Position: ${duration.inMilliseconds}');
      audioPlayerCurrentPosition.value = duration.inMilliseconds;
      print("The current position: ${audioPlayerCurrentPosition.value}");
      update();
    });
  }

  void stopsecondPlayer() async {
    await player.stop(); // will resume from beginning
  }

  void seekplayerPosition(Offset? localPosition, double maxWidth) async {
    // var pos = localPosition.dx < 0
    //     ? 0
    //     : (localPosition.dx > maxWidth ? maxWidth : localPosition.dx);
    //     var calc = (pos / maxWidth);
    //     print("You tapped or dragged me The calc: ${calc}");
    // await player.seek(Duration(milliseconds: calc.toInt()));
    await player.seek(Duration(milliseconds: 15255));
  }

  // int getHeardBarPercentageFromTotal() {
  //   var percentComplete =
  //       (((_messageHeard.value * 1.04) / _speed.value) / _duration.value);

  //   var progress = percentComplete * (_message.value?.durationMs ?? 0);
  //   return progress.toInt();
  // }

}
