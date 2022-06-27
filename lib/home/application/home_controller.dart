import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  final RxList<dynamic> psychologists = <dynamic>[].obs;
  TextEditingController searchController = TextEditingController();
  final RxBool _isSearchOpen = false.obs;
  get searchIsOpen => _isSearchOpen.value;

  @override
  void onReady() {
    getDummyPsychologistsData();
    super.onReady();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future getDummyPsychologistsData() async {
    final String response = await rootBundle.loadString('assets/psychologists.json');
    final data = await jsonDecode(response);
    final items = data['items'];

    psychologists.value = items;
  }

  void openAndCloseSearch() {
    _isSearchOpen.value = !_isSearchOpen.value;
  }
}
