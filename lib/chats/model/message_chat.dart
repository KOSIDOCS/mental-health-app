import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChat {
  final String messageUid;
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String content;
  final int type;
  final bool readMessage;
  final String documentName;
  final double gifWidth;
  final double gifHeight;

  MessageChat({
    required this.messageUid,
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
    required this.readMessage,
    required this.documentName,
    required this.gifWidth,
    required this.gifHeight,
  });

  factory MessageChat.fromMap(Map data, {required String uid}) {
    return MessageChat(
      messageUid: uid,
      idFrom: data['idFrom'] as String,
      idTo: data['idTo'] as String,
      timestamp: data['timestamp'] as String,
      content: data['content'] as String,
      type: data['type'] as int,
      readMessage: data['readMessage'] ?? false,
      documentName: data['documentName'] ?? '',
      gifWidth: data['gifWidth'] ?? 0,
      gifHeight: data['gifHeight'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageUid': messageUid,
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'content': content,
      'type': type,
      'readMessage': readMessage,
      'documentName': documentName,
      'gifWidth': gifWidth,
      'gifHeight': gifHeight,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String uid = doc.id;
    String idFrom = doc.get('idFrom');
    String idTo = doc.get('idTo');
    String timestamp = doc.get('timestamp');
    String content = doc.get('content');
    int type = doc.get('type');
    bool readMessage = doc.get('readMessage') ?? false;
    String documentName = doc.get('documentName') ?? '';
    double gifWidth = doc.get('gifWidth') ?? 0;
    double gifHeight = doc.get('gifHeight') ?? 0;
    return MessageChat(
      messageUid: uid,
      idFrom: idFrom,
      idTo: idTo,
      timestamp: timestamp,
      content: content,
      type: type,
      readMessage: readMessage,
      documentName: documentName,
      gifWidth: gifWidth,
      gifHeight: gifHeight,
    );
  }
}

class TypeMessage {
  TypeMessage._();

  static const int TEXT = 0;
  static const int IMAGE = 1;
  static const int VIDEO = 2;
  static const int AUDIO = 3;
  static const int FILE = 4;
  static const int GIPHY = 5;
  static const int CONTACT = 6;
  static const int LOCATION = 7;
  static const int UNKNOWN = 8;
}
