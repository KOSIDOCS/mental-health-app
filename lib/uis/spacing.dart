import 'package:flutter/material.dart';

class CustomSpacing {
  CustomSpacing._();

  static const double kHorizontalPad = 24.0;
  static const double kBottomSmall = 16.0;
  static const double kArticleTimePad = 34.0;
}

SizedBox customSizedBox({required BuildContext context, required double size}) {
  return SizedBox(height: MediaQuery.of(context).size.height * size);
}

BorderRadius customBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(20.0),
  topRight: Radius.circular(0.0),
  bottomLeft: Radius.circular(20.0),
  bottomRight: Radius.circular(20.0),
);
