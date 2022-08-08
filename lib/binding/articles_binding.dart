import 'package:get/get.dart';
import 'package:mental_health_care_app/articles/application/articles_controller.dart';

class ArticleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ArticlesController>(ArticlesController());
  }
}