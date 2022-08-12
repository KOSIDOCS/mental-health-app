import 'package:flutter/material.dart';
import 'package:mental_health_care_app/articles/model/article_model.dart';
import 'package:mental_health_care_app/articles/widgets/custom_expand_comments.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';

class ArtcleComment extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String comment;
  final String date;
  final int? totalSubComments;
  final VoidCallback? onTap;
  final bool isSubComment;
  final List<SubCommentsModel>? subComments;
  const ArtcleComment(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.comment,
      required this.date,
      this.totalSubComments,
      this.onTap,
      required this.isSubComment,
      this.subComments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSubAvailable = totalSubComments != null && totalSubComments! > 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 36.0,
                    width: 36.0,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    ImagesPlaceHolders.kPsyPlaceholder2,
                    height: 36.0,
                    width: 36.0,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
              ),
              SizedBox(
                height: 6.0,
              ),
              SizedBox(
                //width: MediaQuery.of(context).size.width * 0.65,
                width: isSubComment ? 220.0 : 280.0,
                child: Text(
                  comment,
                  softWrap: true,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0,
                      ),
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              Row(
                children: [
                  Text(
                    date,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.0,
                          color: Colors.grey,
                        ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  isSubComment
                      ? Container()
                      : GestureDetector(
                          onTap: onTap,
                          child: Text(
                            CustomText.kmentalArticleDetailText3,
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.0,
                                      color: Colors.grey,
                                    ),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 14.5,
              ),
              isSubAvailable && isSubComment == false
                  ? CustomExpandComments(
                      comments: subComments!,
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
