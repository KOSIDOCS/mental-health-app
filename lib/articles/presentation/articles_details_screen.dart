import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/articles/application/articles_controller.dart';
import 'package:mental_health_care_app/articles/model/article_model.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';

class ArticleDetailsScreen extends StatefulWidget {
  const ArticleDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  final ArticlesController _articlesController = Get.find();
  late final ArticleModel article;

  @override
  void initState() {
    super.initState();
    article = _articlesController.selectedArticle.value!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
    child: SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(article.picture),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  BackButton(
                    color: AppColors.mentalPureWhite,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print('Bookmark tapped');
                      }
                    },
                    child: Image.asset(
                      'assets/images/${BrandImages.kIconUploadIcon}',
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 28, right: 24.0),
                    child: Image.asset(
                      'assets/images/${BrandImages.kIconBookmark}',
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.418,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        color: AppColors.mentalBarUnselected,
                        size: 18.0,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        "${article.minRead} min",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                              color: AppColors.mentalBarUnselected,
                            ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    article.date,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: AppColors.mentalBarUnselected,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.47,
            child: Container(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            /// <-- The article heading is displayed -->
                  SizedBox(
                    width: 300.0,
                    child: Text(
                      article.name,
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
              /// <-- The article content body is displayed -->
                  // Container(
                  //   height: MediaQuery.of(context).size.height,
                  //   col
                  //   child: Text(
                  //     article.body,
                  //     style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 16.0,
                  //           fontStyle: FontStyle.normal,
                  //         ),
                  //   ),

                  // ),
                  Container(
                    width: 300.0,
                    height: 600.0,
                    color: Colors.amber,
                  ),
                  Container(
                    width: 300.0,
                    height: 600.0,
                    color: Colors.amber,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
      ),
    );
    
  }
}
