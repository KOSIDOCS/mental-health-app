import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/articles/model/article_model.dart';
import 'package:mental_health_care_app/uis/firestore_constants.dart';

class ArticlesController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final FirebaseFirestore _firestoreDB = Get.find();
  RxList<ArticleModel> _articles = <ArticleModel>[].obs;
  Rxn<ArticleModel> selectedArticle = Rxn<ArticleModel>();
  List<ArticleModel> get getAllArticles => _articles;
  // final List<ArticleModel> articles = [
  //   ArticleModel(picture: "https://firebasestorage.googleapis.com/v0/b/mental-heath-care.appspot.com/o/articlesImages%2FRectangle%20738.png?alt=media&token=673e6ac5-aaa2-4579-8308-f02f3f2cf969", name: "Jealousy: where does it come from and how be with it?", minRead: 5, date: "February 3, 2022"),
  //   ArticleModel(picture: "https://firebasestorage.googleapis.com/v0/b/mental-heath-care.appspot.com/o/articlesImages%2FRectangle%20738.png?alt=media&token=673e6ac5-aaa2-4579-8308-f02f3f2cf969", name: "Jealousy: where does it come from and how be with it?", minRead: 5, date: "February 3, 2022"),
  //   ArticleModel(picture: "https://firebasestorage.googleapis.com/v0/b/mental-heath-care.appspot.com/o/articlesImages%2FRectangle%20738.png?alt=media&token=673e6ac5-aaa2-4579-8308-f02f3f2cf969", name: "Jealousy: where does it come from and how be with it?", minRead: 5, date: "February 3, 2022"),
  //   ArticleModel(picture: "https://firebasestorage.googleapis.com/v0/b/mental-heath-care.appspot.com/o/articlesImages%2FRectangle%20738.png?alt=media&token=673e6ac5-aaa2-4579-8308-f02f3f2cf969", name: "Jealousy: where does it come from and how be with it?", minRead: 5, date: "February 3, 2022"),
  //   ArticleModel(picture: "https://firebasestorage.googleapis.com/v0/b/mental-heath-care.appspot.com/o/articlesImages%2FRectangle%20738.png?alt=media&token=673e6ac5-aaa2-4579-8308-f02f3f2cf969", name: "Jealousy: where does it come from and how be with it?", minRead: 5, date: "February 3, 2022"),
  //   ArticleModel(picture: "https://firebasestorage.googleapis.com/v0/b/mental-heath-care.appspot.com/o/articlesImages%2FRectangle%20738.png?alt=media&token=673e6ac5-aaa2-4579-8308-f02f3f2cf969", name: "Jealousy: where does it come from and how be with it?", minRead: 5, date: "February 3, 2022"),
  // ];

  @override
  void onReady() {
    super.onReady();
    getRealDatas();
  }


  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  RxBool _isSearchOpen = false.obs;
  get getIsSearchOpen => _isSearchOpen.value;


  void openAndCloseSearch() {
    _isSearchOpen.value = !_isSearchOpen.value;
  }
  
  /// this function is used to get the articles from the dummy json file
  Future getDummyPsychologistsData() async {
    final String response =
        await rootBundle.loadString('assets/articles.json');
    final data = await jsonDecode(response);
    final items = data['items'] as List;

    if (items.length != 0) {
      items.forEach((element) async {
        await _firestoreDB.collection(FirestoreConstants.pathArticlesCollection).add(element).then((value) =>
          print("this is value ${value.id}")
        );
      });
    }
  }
  
  /// will get all the articles from the firestore database
  Future getRealDatas() async {
    var firebaseArticles = _firestoreDB.collection(FirestoreConstants.pathArticlesCollection).get();

    List<ArticleModel> allArticles =
        await firebaseArticles.then((value) {
      return value.docs.map((e) {
        return ArticleModel.fromMap(e.data(), uid: e.id);
      }).toList();
    });

    if (allArticles.isNotEmpty) {
      _articles.value = allArticles;
      print("this is the articles ${_articles}");
    }
  }

  void setSelectedArticles({ required ArticleModel article }) {
    selectedArticle.value = article;
    Get.toNamed("/articles/article-details");
  }
}