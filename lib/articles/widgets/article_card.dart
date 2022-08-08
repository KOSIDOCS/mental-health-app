import 'package:flutter/material.dart';
import 'package:mental_health_care_app/articles/model/article_model.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback? onTap;
  const ArticleCard({Key? key, required this.article, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
              width: 285.0,
              margin: EdgeInsets.only(right: 30.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.mentalBarUnselected,
                  width: 0.1,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        child: Container(
                          height: 155.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(article.picture),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16.0,
                        top: 14.0,
                        child: Icon(
                          Icons.bookmark_outline_rounded,
                          color: AppColors.mentalPureWhite,
                          size: 32.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: AppColors.mentalBarUnselected,
                          size: 23.0,
                        ),
                        Text(
                          '${article.minRead} min',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 10.0,
                                color: AppColors.mentalBarUnselected,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          article.date,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 10.0,
                                color: AppColors.mentalBarUnselected,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 17.0, right: 17.0, bottom: 8.0),
                    child: Text(
                      article.name,
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}