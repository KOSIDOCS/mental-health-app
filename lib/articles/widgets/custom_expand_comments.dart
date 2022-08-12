
import 'package:flutter/material.dart';
import 'package:mental_health_care_app/articles/model/article_model.dart';
import 'package:mental_health_care_app/articles/widgets/article_comments.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/custom_texts.dart';
import 'package:mental_health_care_app/utils/alignment_helpers.dart';

class CustomExpandComments extends StatefulWidget {
  final List<SubCommentsModel> comments;
  const CustomExpandComments({Key? key, required this.comments})
      : super(key: key);

  @override
  State<CustomExpandComments> createState() => _CustomExpandCommentsState();
}

class _CustomExpandCommentsState extends State<CustomExpandComments>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: leftAligned(),
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                  setState(() {
                    _isExpanded = true;
                  });
                } else {
                  _controller.reverse();
                  setState(() {
                    _isExpanded = false;
                  });
                }
              },
              child: _isExpanded
                  ? Row(
                      children: [
                        Container(
                          width: 23.0,
                          height: 1.0,
                          margin: EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        Text(
                          "Show less",
                          style:
                              Theme.of(context).textTheme.caption!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    color: AppColors.mentalBrandColor,
                                  ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          width: 23.0,
                          height: 1.0,
                          margin: EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        Text(
                          "${CustomText.kmentalArticleDetailText4} ${widget.comments.length} ${CustomText.kmentalArticleDetailText5}",
                          style:
                              Theme.of(context).textTheme.caption!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    color: AppColors.mentalBrandColor,
                                  ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        SizedBox(
          height: 14.0,
        ),
        _isExpanded
            ? Column(
              crossAxisAlignment: leftAligned(),
                children: [
                  for (var i = 0; i < widget.comments.length; i++)
                    ArtcleComment(
                      name: widget.comments[i].author,
                      imageUrl: widget.comments[i].picture,
                      comment: widget.comments[i].text,
                      date: widget.comments[i].date,
                      isSubComment: true,
                    ),
                ],
              )
            : Container(),
      ],
    );
  }
}
