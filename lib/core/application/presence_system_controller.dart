import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class PresenceSystemController extends GetxController {
  FirebaseDatabase database = Get.find();
  StreamSubscription? subscription;
  DatabaseReference? con;
  RxBool isOnline = false.obs;

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }

  Future<void> getPsychologistPresence({ required String uid }) async {
    database.ref().child('presence').child(uid).onValue.listen((event) {
      if (event.snapshot.value != null) {
        isOnline.value = true;
      }else {
        isOnline.value = false;
      }
    });
  }

  // Configure user presence
  Future<void> configureUserPresence(String uid) async {
    final myConnectionsRef =
        database.ref().child('presence').child(uid).child('connections');
    final lastOnlineRef =
        database.ref().child('presence').child(uid).child('lastOnline');
// Needs to go back online if once gone offline i.g. logging out and inn
    await database.goOnline();
/*
      Need to have an extra listener just so, there some listener left after onDisconnect
      triggers, since if there are no listeners left, the listener to .info/connected
      will stop listening after 60 second.
    */
    database.ref().child('presence').child(uid).onValue.listen((event) {});
    subscription =
        database.ref().child('.info/connected').onValue.listen((event) {
      if (event.snapshot.value != null) {
        // We're connected (or reconnected)! Do anything here that should happen only if online (or on reconnect)
        con = myConnectionsRef.push();

        print('I am online now ${event.snapshot.value}');

        // When I disconnect remove this device
        con?.onDisconnect().remove();

        // Add this device to my connections list
        // this value could contain info about the device or a timestamp too
        con?.set(true);

        // When I disconnect, update the last time I was seen online
        lastOnlineRef.onDisconnect().set(ServerValue.timestamp);
      }
    });
  }

  // Connect back to the firebase realtime database
  void connect() {
    print("Connected here now");
    database.goOnline();
  }

// Remove connection for this device when signing out
  void disconnect({bool signout = false}) {
    if (signout && subscription != null) {
      subscription?.cancel();
    }
    print("Connected here now");
    database.goOffline();
  }
}

// {
//   "rules": {
//     ".read": false,
//     ".write": false
//   }
// }