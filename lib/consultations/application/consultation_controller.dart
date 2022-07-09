import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/consultations/model/appoinment_model.dart';

class ConsultationController extends GetxController {
  RxList<AppoinmentModel> _consultations = <AppoinmentModel>[].obs;
  final FirebaseFirestore _db = Get.find();
  final FirebaseAuth _authentication = Get.find();
  // final AuthController _auth = Get.find();
  final RxString _filter = ''.obs;

  get allConsultation => _consultations;

  get getFilter => _filter.value;


  @override
  void onReady() {
    getConsultations();
    super.onReady();
  }


  Future getConsultations() async {
    var userCollection = _db.collection('users').doc(_authentication.currentUser!.uid).get();
    
    await userCollection.then((value) {
      print(value.data());

      value.data()!['consultations'].forEach((element) {
        _consultations.add(AppoinmentModel.fromMap(element));
      });
    });
  }

  addBottomSearchParam(String param) {
    _filter.value = param;
  }

  bool checkFilterExists(String param) {
    return _filter.value.contains(param);
  }

  void clearBottomSearch() { 
    _filter.value = '';
    _consultations.value = [];
    getConsultations();
  }

  void bottomSearchFilter() {
    _consultations.value = _consultations.where((element) {
      return element.type.toLowerCase().contains(_filter.value.toLowerCase());
    }).toList();
  }

  void pushToDetailsScreen(AppoinmentModel model) {
    Get.toNamed('/consultations/consultation-details', arguments: model);
  }
}