import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mental_health_care_app/auth/domain/user_model.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = Get.find();
  final FirebaseFirestore _db = Get.find();
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  RxBool disableSignUpbutton = false.obs;

  late Timer _timer;

  @override
  void onReady() {
    //run every time the auth state changes
    ever(firebaseUser, handleAuthChanged);

    firebaseUser.bindStream(user);
    super.onReady();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  handleAuthChanged(_firebaseUser) async {
    //get user data from firestore
    if (_firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());
    }

    if (_firebaseUser == null) {
      print('Send to signin');
      _timer = Timer(const Duration(seconds: 3), () {
        Get.offAllNamed('/onboard');
      });
    } else {
      print('Send to Home');
      _timer = Timer(const Duration(seconds: 3), () {
        Get.offAllNamed('/home');
      });
      // Get.offAllNamed('/home');
    }
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamFirestoreUser() {
    UserModel _user = UserModel(
      email: '',
      name: '',
      photoUrl: '',
      uid: '',
    );
    print(
        'streamFirestoreUser() ${firebaseUser.value!.uid} ${firebaseUser.value}');

    print(_db.doc('/users/${firebaseUser.value!.uid}').snapshots());

    return _db.doc('/users/${firebaseUser.value!.uid}').snapshots().map(
        (snapshot) => snapshot.data() != null
            ? UserModel.fromMap(snapshot.data()!)
            : _user);
  }

  // User registration using email and password
  void registerWithEmailAndPassword(
      {required String email, required String password}) async {
    disableSignUpbutton.value = true;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        disableSignUpbutton.value = false;
        print('Created account successful with: $value');
      }).catchError((error) {
        disableSignUpbutton.value = false;
        print(error);
      });
    } on FirebaseAuthException catch (e, stack) {
      disableSignUpbutton.value = false;
      print("googleSignIn Error: $e $stack");

      Get.snackbar(
        'Email Sign Up',
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: AppColors.mentalBrandColor,
        colorText: AppColors.mentalBrandLightColor,
      );
    }
  }

  void googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await _auth.signInWithCredential(credential).then((value) {
          print('Signed in with google: $value');
        });
      }
    } on FirebaseAuthException catch (e, stack) {
      print("googleSignIn Error: $e $stack");

      Get.snackbar(
        'Google Sign In',
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: AppColors.mentalBrandColor,
        colorText: AppColors.mentalBrandLightColor,
      );
    }
  }

  void userSignOut() async {
    await _auth.signOut();
  }
}
