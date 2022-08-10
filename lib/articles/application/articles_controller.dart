import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/articles/model/article_model.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/home/application/home_controller.dart';
import 'package:mental_health_care_app/home/model/psychologist_model.dart';
import 'package:mental_health_care_app/uis/firestore_constants.dart';
import 'package:mental_health_care_app/utils/time_formatter.dart';

class ArticlesController extends GetxController {
  TextEditingController searchController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  final FirebaseFirestore _firestoreDB = Get.find();
  final HomeController _homeController = Get.find();
  final AuthController _authController = Get.find();
  RxList<ArticleModel> _articles = <ArticleModel>[].obs;
  Rxn<ArticleModel> selectedArticle = Rxn<ArticleModel>();
  Rxn<PsychologistModel> articlePsychologist = Rxn<PsychologistModel>();
  List<ArticleModel> get getAllArticles => _articles;
  RxBool replyComment = false.obs;
  RxString replyCommentAuthorName = "".obs;

  @override
  void onReady() {
    super.onReady();
    getRealDatas();
  }

  @override
  void onClose() {
    searchController.dispose();
    commentController.dispose();
    super.onClose();
  }

  RxBool _isSearchOpen = false.obs;
  get getIsSearchOpen => _isSearchOpen.value;

  void openAndCloseSearch() {
    _isSearchOpen.value = !_isSearchOpen.value;
  }

  /// this function is used to get the articles from the dummy json file
  Future getDummyPsychologistsData() async {
    final String response = await rootBundle.loadString('assets/articles.json');
    final data = await jsonDecode(response);
    final items = data['items'] as List;

    if (items.length != 0) {
      items.forEach((element) async {
        await _firestoreDB
            .collection(FirestoreConstants.pathArticlesCollection)
            .add(element)
            .then((value) => print("this is value ${value.id}"));
      });
    }
  }

  /// will get all the articles from the firestore database
  Future getRealDatas() async {
    var firebaseArticles = _firestoreDB
        .collection(FirestoreConstants.pathArticlesCollection)
        .get();

    List<ArticleModel> allArticles = await firebaseArticles.then((value) {
      return value.docs.map((e) {
        return ArticleModel.fromMap(e.data(), uid: e.id);
      }).toList();
    });

    if (allArticles.isNotEmpty) {
      _articles.value = allArticles;
      print("this is the articles ${_articles}");
    }
  }

  void setSelectedArticles({required ArticleModel article}) {
    selectedArticle.value = article;
    articlePsychologist.value = _homeController.psychologists
        .firstWhere((element) => element.uid == article.authorId);
    Get.toNamed("/articles/article-details");
  }

  void addComments() {
    if (commentController.text.isNotEmpty) {
      final dBcomment = {
        "author": _authController.firestoreUser.value?.name ?? "Uknown",
        "author_id": _authController.firebaseUser.value?.uid,
        "date": TimFormatter.formatCommentDate(dateTime: DateTime.now()),
        "picture": _authController.firestoreUser.value?.photoUrl ?? "",
        "sub_comments": [],
        "text": commentController.text,
      };
      commentController.clear();
      selectedArticle.value?.comments.add(dBcomment);
      
      if (replyCommentAuthorName.value.isNotEmpty) {
        final dBubcomment = {
        "author": _authController.firestoreUser.value?.name ?? "Uknown",
        "author_id": _authController.firebaseUser.value?.uid,
        "date": "August 10, 2022",
        "picture": _authController.firestoreUser.value?.photoUrl ?? "",
        "sub_comments": FieldValue.arrayUnion([
          {
            "author": _authController.firestoreUser.value?.name ?? "Uknown",
            "author_id": _authController.firebaseUser.value?.uid,
            "date": TimFormatter.formatCommentDate(dateTime: DateTime.now()),
            "picture": _authController.firestoreUser.value?.photoUrl ?? "",
            "text": commentController.text,
          }
        ]),
        "text": "Help me please 😩",
      };
        _firestoreDB
          .collection(FirestoreConstants.pathArticlesCollection)
          .doc(selectedArticle.value?.id)
          .update({
        "comments": FieldValue.arrayUnion([dBcomment]),
      });
      } else {
        _firestoreDB
          .collection(FirestoreConstants.pathArticlesCollection)
          .doc(selectedArticle.value?.id)
          .update({
        "comments": FieldValue.arrayUnion([dBcomment]),
      });
      } 
      }
    }
  }
  
  /// This function helps us to know which comment the user tapped
  /// on and we can keep track of the comment that the user tapped.
  void setReplyComment({required int index}) {
    replyCommentAuthorName.value = selectedArticle.value?.comments[index]["author"];
    replyComment.value = true;
  }
  
  /// Reset the value of [replyComment] which holds the current
  /// comment that the user tapped on to null.
  void cancelReplyComment() {
    replyComment.value = false;
    replyCommentAuthorName.value = "";
  }
}
