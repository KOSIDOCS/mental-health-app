import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mental_health_care_app/auth/domain/user_model.dart';
import 'package:mental_health_care_app/core/application/presence_system_controller.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/uis/custom_modals.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = Get.find();
  final FirebaseFirestore _db = Get.find();
  final FirebaseStorage storage = Get.find();
  PresenceSystemController _presenceSystemController = Get.put(PresenceSystemController());
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  RxBool disableSignUpbutton = false.obs;
  RxBool disableSignInbutton = false.obs;
  RxBool disableResetPassword = false.obs;

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
      conversations: <String>[],
    );
    print(
        'streamFirestoreUser() ${firebaseUser.value!.uid} ${firebaseUser.value}');

    print(_db.doc('/users/${firebaseUser.value!.uid}').snapshots());

    return _db.doc('/users/${firebaseUser.value!.uid}').snapshots().map(
        (snapshot) => snapshot.data() != null
            ? UserModel.fromMap(snapshot.data()!)
            : _user);
  }

  // Method to handle user sign in with email and password
  signInWithEmailAndPassword(
      {required String email, required String password}) async {
    disableSignInbutton.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      disableSignInbutton.value = false;
    } on FirebaseAuthException catch (e, stack) {
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

  void facebookSignIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        print('User data: $userData');
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
          result.accessToken!.token,
        );
        await _auth.signInWithCredential(facebookAuthCredential).then((value) {
          print('Signed in with facebook: $value');
        });
      }
    } on FirebaseAuthException catch (e, stack) {
      print("googleSignIn Error: $e $stack");

      Get.snackbar(
        'Facebook Sign In',
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: AppColors.mentalBrandColor,
        colorText: AppColors.mentalBrandLightColor,
      );
    }
  }

  signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final AuthorizationCredentialAppleID appleCredential;

      if (GetPlatform.isAndroid) {
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: dotenv.env['CLIENTID']!,
            redirectUri: Uri.parse(dotenv.env['REDIRECTURL_2']!),
          ),
          nonce: nonce,
        );
      } else {
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );
      }

      final authCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      await _auth.signInWithCredential(authCredential).then((value) {
        print('Signed in with apple: $value');
      });
    } on FirebaseAuthException catch (e, stack) {
      print("googleSignIn Error: $e $stack");

      Get.snackbar(
        'Apple Sign In',
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: AppColors.mentalBrandColor,
        colorText: AppColors.mentalBrandLightColor,
      );
    }
  }

  // Method to handle user reset password request
  userForgotPassword(
      {required String email, required BuildContext context}) async {
    disableResetPassword.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        customBottomSheet(
          content: Text('Here is modal'),
          context: context,
          title: '',
          onPressed: () async {
            print('clicked');
            // Android: Will open mail app or show native picker.
            // iOS: Will open mail app if single mail app found.
            var result = await OpenMailApp.openMailApp();

            if (!result.didOpen && !result.canOpen) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Open Mail App"),
                    content: Text("No mail apps installed"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (_) {
                  return MailAppPickerDialog(
                    mailApps: result.options,
                  );
                },
              );
            }
          },
        );
        disableResetPassword.value = false;
      });
    } on FirebaseAuthException catch (e, stack) {
      print("googleSignIn Error: $e $stack");

      Get.snackbar(
        'Forgot Password',
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: AppColors.mentalBrandColor,
        colorText: AppColors.mentalBrandLightColor,
      );
    }
  }

  void userSignOut() async {
    _presenceSystemController.disconnect(signout: true);
    await _auth.signOut();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
