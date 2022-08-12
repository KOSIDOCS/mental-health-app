import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:mental_health_care_app/articles/application/articles_controller.dart';
import 'package:mental_health_care_app/articles/model/article_model.dart';
import 'package:mental_health_care_app/articles/widgets/article_comments.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/makeappointment/widgets/appointment_user_card.dart';
import 'package:mental_health_care_app/uis/custom_buttons.dart';
import 'package:mental_health_care_app/uis/custom_input_fields.dart';
import 'package:mental_health_care_app/uis/spacing.dart';
import 'package:mental_health_care_app/utils/focus_helper.dart';
import 'package:mental_health_care_app/utils/time_formatter.dart';

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
  void dispose() {
    _articlesController.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //dom.Document document = htmlparser.parse(article.body);
    return GestureDetector(
      onTap: () {
        hideKeyboard(context: context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned(
              top: 0.0,
              child: Container(
                height: 360.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(article.picture),
                    fit: BoxFit.cover,
                  ),
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
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.4,
              bottom: MediaQuery.of(context).size.height * 0.11,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            left: CustomSpacing.kArticleTimePad,
                            right: CustomSpacing.kArticleTimePad,
                          ),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
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
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.0,
                                      color: AppColors.mentalBarUnselected,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),

                        /// <-- The article content body is displayed -->
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: CustomSpacing.kHorizontalPad,
                          ),
                          child: Html(
                            data: article.body,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: CustomSpacing.kArticleTimePad,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CustomText.kmentalArticleDetailText1,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0,
                                      color: AppColors.mentalBarUnselected,
                                    ),
                              ),
                              Divider(
                                color: AppColors.mentalBarUnselected,
                                thickness: 0.2,
                              ),
                              AppointmentUserCard(
                                name: _articlesController
                                    .articlePsychologist.value!.name,
                                imageUrl: _articlesController
                                    .articlePsychologist.value!.userImage,
                                availability: TimFormatter.formatTimeUserCard(
                                  dateTime: _articlesController
                                      .articlePsychologist.value!.earlyAdmit,
                                ),
                              ),
                              SizedBox(
                                height: 14.0,
                              ),
                              Divider(
                                color: AppColors.mentalBarUnselected,
                                thickness: 0.2,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                CustomText.kmentalArticleDetailText2,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17.0,
                                    ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              for (var i = 0;
                                  i < _articlesController.loadMoreLength.value;
                                  i++)
                                ArtcleComment(
                                  name: article.comments[i].author,
                                  imageUrl: article.comments[i].picture,
                                  comment: article.comments[i].text,
                                  date: article.comments[i].date,
                                  totalSubComments:
                                      article.comments[i].subComments.length,
                                  onTap: () {
                                    _articlesController.setReplyComment(
                                        index: i);
                                  },
                                  isSubComment: false,
                                  subComments: article.comments[i].subComments,
                                ),
                              _articlesController.hideLoadMore()
                                  ? Container()
                                  : Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: () {
                                          _articlesController
                                              .loadMoreComments();
                                        },
                                        child: Text(
                                          CustomText.kmentalArticleDetailText8,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15.0,
                                              ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 90.0,
                        // ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() {
                return _articlesController.replyComment == false
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 130.0,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding:
                            EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              CustomText.kmentalArticleDetailText6,
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: AppColors.mentalBarUnselected,
                                      ),
                            ),
                            Text(
                              _articlesController.replyCommentAuthorName.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                _articlesController.cancelReplyComment();
                              },
                              child: Text(
                                CustomText.kmentalArticleDetailText7,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      color: AppColors.mentalBarUnselected,
                                    ),
                              ),
                            )
                          ],
                        ),
                      );
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Divider(
                      color: AppColors.mentalBarUnselected,
                      thickness: 0.3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.25,
                        vertical: 6.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          JustTheTooltip(
                            isModal: true,
                            offset: 10.0,
                            backgroundColor: AppColors.mentalBrandColor,
                            child: Image.asset(
                              'assets/images/${BrandImages.kIconAttach}',
                              height: 22.5,
                              width: 19.88,
                            ),
                            content: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                CustomText.kmentalComingSoonFeatureText,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      color: AppColors.mentalPureWhite,
                                    ),
                              ),
                            ),
                          ),
                          CustomChatField(
                            controller: _articlesController.commentController,
                            keyboardType: TextInputType.text,
                            placeholder: 'Comment',
                            hideEmojiBtn: true,
                          ),
                          CustomCirclerBtn(
                            imgName: BrandImages.kIconSendIcon,
                            onPressed: () {
                              _articlesController.addComments();
                            },
                            redus: 19.5,
                            bagroundRadius: 20.0,
                            imgHeight: 22.5,
                            imgWidth: 16.88,
                            padding: const EdgeInsets.all(0.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
