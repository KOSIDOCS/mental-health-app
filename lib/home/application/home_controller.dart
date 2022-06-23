import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  final RxList<dynamic> psychologists = <dynamic>[].obs;

  @override
  void onReady() {
    getDummyPsychologistsData();
    super.onReady();
  }

  Future getDummyPsychologistsData() async {
    final String response = await rootBundle.loadString('assets/psychologists.json');
    final data = await jsonDecode(response);
    final items = data['items'];

    psychologists.value = items;
  }
}
