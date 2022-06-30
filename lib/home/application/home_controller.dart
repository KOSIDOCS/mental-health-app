import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AuthController authController = Get.put(AuthController());
  late TabController tabController = TabController(length: 6, vsync: this);
  final FirebaseFirestore _db = Get.find();
  final RxList<dynamic> psychologists = <dynamic>[].obs;
  final RxList<dynamic> psychologistsList = <dynamic>[].obs;
  final RxList<dynamic> gestaltList = <dynamic>[].obs;
  final RxList<dynamic> artTherapyList = <dynamic>[].obs;
  final RxList<dynamic> coachingList = <dynamic>[].obs;
  final RxList<dynamic> familyList = <dynamic>[].obs;
  final RxList<dynamic> careerList = <dynamic>[].obs;
  final RxList<String> bottomSearch = <String>[].obs;
  TextEditingController searchController = TextEditingController();
  final RxBool _isSearchOpen = false.obs;
  get searchIsOpen => _isSearchOpen.value;

  @override
  void onReady() {
    //getDummyPsychologistsData();
    getRealDatas();
    super.onReady();
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  Future getDummyPsychologistsData() async {
    final String response =
        await rootBundle.loadString('assets/psychologists.json');
    final data = await jsonDecode(response);
    final items = data['items'];

    psychologists.value = items;
    psychologistsList.value = psychologists;
  }

  Future getRealDatas() async {
    var firebasePsychologists = _db.collection('psychologists').get();

    List<Map<String, dynamic>> allPsychologists =
        await firebasePsychologists.then((value) {
      return value.docs.map((e) {
        return e.data();
      }).toList();
    });

    if (allPsychologists.isNotEmpty) {
      psychologists.value = allPsychologists;
      resetFilterList();
    }
  }

  void openAndCloseSearch() {
    _isSearchOpen.value = !_isSearchOpen.value;
  }

  void searchPsychologists() {
    print('current tab: ${tabController.index}');
    if (searchController.text.isEmpty) {
      resetFilterList();
    } else {
      searchTabs(tabController.index);
      // psychologistsList.value = psychologists.where((item) => item['name'].toString().toLowerCase().contains(searchController.text.toLowerCase())).toList();
    }
  }

  void resetFilterList() {
    psychologistsList.value = psychologists;
    gestaltList.value = psychologists
        .where((element) => element["specialization"] == 'Gestalt')
        .toList();
    artTherapyList.value = psychologists
        .where((element) => element["specialization"] == 'Art therapy')
        .toList();
    coachingList.value = psychologists
        .where((element) => element["specialization"] == 'Coaching')
        .toList();
    familyList.value = psychologists
        .where((element) => element["specialization"] == 'Family')
        .toList();
    careerList.value = psychologists
        .where((element) => element["specialization"] == 'Career')
        .toList();
  }

  void searchTabs(int currentTab) {
    switch (currentTab) {
      case 0:
        psychologistsList.value = psychologistsList
            .where((item) => item['name']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        break;
      case 1:
        gestaltList.value = gestaltList
            .where((element) => element['name']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        break;
      case 2:
        artTherapyList.value = artTherapyList
            .where((element) => element['name']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        break;
      case 3:
        coachingList.value = coachingList
            .where((element) => element['name']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        break;
      case 4:
        familyList.value = familyList
            .where((element) => element['name']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        break;
      case 5:
        careerList.value = careerList
            .where((element) => element['name']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        break;
      default:
    }
  }

  void bottomSearchFilter() {
    if(bottomSearch.isNotEmpty) {
      filterCriteria(bottomSearch.length);
    }
  }

  void filterCriteria(int criterial) {
    switch (criterial) {
      case 1:
        psychologistsList.value = psychologistsList
            .where((item) => item['star'] >= 4.8)
            .toList();
        break;
      case 2:
         psychologistsList.value = psychologistsList
              .where((item) => item['star'] >= 4.0)
              .toList();
          break;
      case 3:
        psychologistsList.value = psychologistsList
            .where((item) => item['min_amount'] <= 100.0)
            .toList();
        break;
      case 4: 
        psychologistsList.value = psychologistsList
            .where((item) => item['min_amount'] >= 500.0)
            .toList();
        break;
      case 5:
        psychologistsList.value = psychologistsList
            .where((item) => item['experience'] >= 4)
            .toList();
        break;          
      default:
    }
  }

  dynamic getFilterDefault(String filter) {
    if(filter == CustomText.mentalBottomSearchText1) {
      return 4.0;
    } else if(filter == CustomText.mentalBottomSearchText2) {
      return 4.8;
    } else if(filter == CustomText.mentalBottomSearchText3) {
      return 100.0;
    } else if(filter == CustomText.mentalBottomSearchText4){
      return 500.0;
    }else {
      return 4;
    }
  }

  // void updateBottomSearchList(String value) {
  //   bottomSearch.value = bottomSearch.add(value);
  // }

  // void uploadDummy() {
  //   psychologists.forEach((element) async {
  //     getImageFileFromAssets('images/' + element['user_image'], element['user_image'].split('.').first).then((file) async {
  //       var url = await uploadUserImages(image: file, imageName: element['user_image']);
  //       print("this is url $url");
  //       element['user_image'] = url;
  //       await _db.collection('psychologists').add(element).then((value) =>
  //         print("this is value ${value.id}")
  //       );
  //       if (kDebugMode) {
  //         print("file is ${file.path}");
  //       }
  //     });
  //   });
  // }

  // Future<File> getImageFileFromAssets(String path, String pathName) async {
  //   final byteData = await rootBundle.load('assets/$path');
  //   final buffer = byteData.buffer;
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   var filePath =
  //       '$tempPath/$pathName.tmp'; // file_01.tmp is dump file, can be anything
  //   return File(filePath).writeAsBytes(
  //       buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  // }

  // Future<String> uploadUserImages({required File image, required String imageName}) async {
  //   final imgToUpload = File(image.path);
  //   Reference imgRef;
  //   String imgUrl = '';
  //   imgRef = authController.storage.ref().child('PsychologistsImages/$imageName');
  //   await imgRef.putFile(imgToUpload).whenComplete(() async {
  //     await imgRef.getDownloadURL().then((url) {
  //       imgUrl = url;
  //       if (kDebugMode) {
  //         print('Image uploaded to firebase storage: $url');
  //       }
  //     });
  //   });
  //   return imgUrl;
  // }
}
