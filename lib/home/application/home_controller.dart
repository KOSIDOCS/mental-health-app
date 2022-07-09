import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/auth/application/auth_controller.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/home/model/psychologist_model.dart';

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
  final Rxn<PsychologistModel> selectedPsychologist = Rxn<PsychologistModel>();
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
    if (bottomSearch.isNotEmpty) {
      filterCriteria(bottomSearch[0]);
    }
  }

  void filterCriteria(String criterial) {
    Map<String, dynamic> filterDefault = getFilterDefault(criterial);
    switch (filterDefault['type']) {
      case 'high_rate':
        psychologistsList.value = psychologistsList
            .where((item) => item['star'] >= filterDefault['value'])
            .toList()
          ..sort((a, b) => b['star'].compareTo(a['star']));
        break;
      case 'early_admit':
        psychologistsList.value = psychologistsList
            .where((item) =>
                DateTime.parse(item['early_admit'])
                    .difference(DateTime.now())
                    .inDays <=
                filterDefault['value'])
            .toList();
        break;
      case 'min_amount':
        psychologistsList.value = psychologistsList
            .where((item) => item['min_amount'] < filterDefault['value'])
            .toList()..sort((a, b) => a['min_amount'].compareTo(b['min_amount']));
        break;
      case 'high_amount':
        psychologistsList.value = psychologistsList
            .where((item) => item['min_amount'] >= filterDefault['value'])
            .toList()..sort((a, b) => b['min_amount'].compareTo(a['min_amount']));
        break;
      case 'experience':
        psychologistsList.value = psychologistsList
            .where((item) => item['experience'] >= filterDefault['value'])
            .toList()..sort((a, b) => b['experience'].compareTo(a['experience']));
        break;
      default:
    }
  }

  Map<String, dynamic> getFilterDefault(String filter) {
    if (filter == CustomText.mentalBottomSearchText1) {
      return {'type': 'high_rate', 'value': 4.8};
    } else if (filter == CustomText.mentalBottomSearchText2) {
      return {'type': 'early_admit', 'value': 10};
    } else if (filter == CustomText.mentalBottomSearchText3) {
      return {'type': 'min_amount', 'value': 500.0};
    } else if (filter == CustomText.mentalBottomSearchText4) {
      return {'type': 'high_amount', 'value': 500.0};
    } else {
      return {'type': 'experience', 'value': 4};
    }
  }

  void addBottomSearchParam(String value) {
    if (bottomSearch.length < 1 || bottomSearch[0] == value) {
      if (bottomSearch.contains(value)) {
        bottomSearch.remove(value);
      } else {
        bottomSearch.add(value);
      }
    }
  }

  bool checkFilterExists(String value) {
    return bottomSearch.contains(value);
  }

  void clearBottomSearch() {
    bottomSearch.clear();
    resetFilterList();
  }

  void setSelectedPsychologist(int index) {
    print('selected psychologist: ${psychologistsList[index]}');
    selectedPsychologist.value = PsychologistModel.fromMap(psychologistsList[index], uid: 'hhji');
    
    if (selectedPsychologist.value != null) {
      Get.toNamed('/home/detailspage');
    }
  }

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
