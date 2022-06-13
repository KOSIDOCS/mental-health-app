import 'package:flutter/material.dart';

class CustomSpacing {
  CustomSpacing._();
  
  static const double kHorizontalPad = 24.0;
  static const double kBottomSmall = 16.0;
}

SizedBox customSizedBox({required BuildContext context, required double size}) {
  return SizedBox(height: MediaQuery.of(context).size.height * size);
}