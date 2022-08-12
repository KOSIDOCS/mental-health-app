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

const kMinimumCommentLength = 5;

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
  RxInt replyCommentIndex = 0.obs;
  RxInt loadMoreLength = 0.obs;

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
      print("this is the articles ${_articles}, ${_articles[0].comments}");
    }
  }

  void setSelectedArticles({required ArticleModel article}) {
    selectedArticle.value = article;
    loadMoreLength.value = article.comments.length < kMinimumCommentLength
        ? article.comments.length
        : kMinimumCommentLength;
    articlePsychologist.value = _homeController.psychologists
        .firstWhere((element) => element.uid == article.authorId);
    Get.toNamed("/articles/article-details");
  }

  void addComments() {
    if (commentController.text.isNotEmpty) {
      // final dBcomment = {
      //   "author": _authController.firestoreUser.value?.name ?? "Uknown",
      //   "author_id": _authController.firebaseUser.value?.uid,
      //   "date": TimFormatter.formatCommentDate(dateTime: DateTime.now()),
      //   "picture": _authController.firestoreUser.value?.photoUrl ?? "",
      //   "sub_comments": [],
      //   "text": commentController.text,
      // };

      final dBcomment = CommentsModel(
          author: _authController.firestoreUser.value?.name ?? "Uknown",
          authorId: _authController.firebaseUser.value?.uid as String,
          date: TimFormatter.formatCommentDate(dateTime: DateTime.now()),
          picture: _authController.firestoreUser.value?.photoUrl ?? "",
          text: commentController.text,
          subComments: []
        );

      if (replyCommentAuthorName.value.isNotEmpty) {
        // final subComments = {
        //   "author": _authController.firestoreUser.value?.name ?? "Uknown",
        //   "author_id": _authController.firebaseUser.value?.uid,
        //   "date": TimFormatter.formatCommentDate(dateTime: DateTime.now()),
        //   "picture": _authController.firestoreUser.value?.photoUrl ?? "",
        //   "text": commentController.text,
        // };
        final subComments = SubCommentsModel(
          author: _authController.firestoreUser.value?.name ?? "Uknown",
          authorId: _authController.firebaseUser.value?.uid as String,
          date: TimFormatter.formatCommentDate(dateTime: DateTime.now()),
          picture: _authController.firestoreUser.value?.photoUrl ?? "",
          text: commentController.text,
        );
        commentController.clear();
        selectedArticle.value?.comments[replyCommentIndex.value].subComments
            .add(subComments);
        cancelReplyComment();
        _firestoreDB
            .collection(FirestoreConstants.pathArticlesCollection)
            .doc(selectedArticle.value?.id)
            .update({
          // "comments": selectedArticle.value?.comments,
          "comments": List<Map<String, dynamic>>.from(
        selectedArticle.value!.comments.map((x) => x.toMap())
      ),
        });
      } else {
        commentController.clear();
        _firestoreDB
            .collection(FirestoreConstants.pathArticlesCollection)
            .doc(selectedArticle.value?.id)
            .update({
          "comments": FieldValue.arrayUnion([dBcomment.toMap()]),
        });
        selectedArticle.value?.comments.add(dBcomment);
        // loadMoreLength.value = selectedArticle.value!.comments.length <
        //         kMinimumCommentLength
        //     ? selectedArticle.value!.comments.length
        //     : kMinimumCommentLength;
      }
    }
  }

  /// This function helps us to know which comment the user tapped
  /// on and we can keep track of the comment that the user tapped.
  void setReplyComment({required int index}) {
    replyCommentAuthorName.value =
        selectedArticle.value?.comments[index].author as String;
    replyCommentIndex.value = index;
    replyComment.value = true;
  }

  /// Reset the value of [replyComment] which holds the current
  /// comment that the user tapped on to null.
  void cancelReplyComment() {
    replyComment.value = false;
    replyCommentAuthorName.value = "";
    replyCommentIndex.value = 0;
  }

  void loadMoreComments() {
    int length = selectedArticle.value?.comments.length as int;
    if (loadMoreLength.value < length) {
      int next = loadMoreLength.value + kMinimumCommentLength;
      loadMoreLength.value = next > length
          ? length
          : next;
    }
  }

  bool hideLoadMore() {
    int length = selectedArticle.value?.comments.length as int;
    return loadMoreLength.value >= length;
  }

  void reset() {
    loadMoreLength.value = 0;
  }
}
