import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';

class CustomStarsRating extends StatelessWidget {
  final double rating;
  final int totalStars;
  const CustomStarsRating({Key? key, required this.rating, required this.totalStars}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (int i = 0; i < totalStars; i++) {
      stars.add(Icon(
        i < rating.floor() ? Icons.star : Icons.star_border,
        size: 20.0,
        color: AppColors.mentalStarColor,
      ));
    }
    return Row(
      children: stars,
    );
  }
}