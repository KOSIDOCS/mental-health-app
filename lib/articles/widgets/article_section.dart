import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_care_app/articles/application/articles_controller.dart';
import 'package:mental_health_care_app/articles/model/article_model.dart';
import 'package:mental_health_care_app/articles/widgets/article_card.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

class ArticlesSection extends StatelessWidget {
  final List<ArticleModel> articles;
  final String title;
  final ScrollController scrollController;
  ArticlesSection(
      {Key? key,
      required this.articles,
      required this.title,
      required this.scrollController})
      : super(key: key);

  final ArticlesController _articlesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: CustomSpacing.kHorizontalPad,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                ),
          ),
        ),
        Container(
          height: 250.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          margin: EdgeInsets.only(top: 15.0),
          width: MediaQuery.of(context).size.width,
          child: Obx(() {
            return ListView.builder(
              controller: scrollController,
              itemCount: articles.length,
              padding: EdgeInsets.only(left: CustomSpacing.kHorizontalPad),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ArticleCard(
                  article: article,
                  onTap: () =>
                      _articlesController.setSelectedArticles(article: article),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
