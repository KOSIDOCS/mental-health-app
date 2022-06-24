import 'package:flutter/material.dart';

abstract class CustomStatefulUIState<T extends StatefulWidget> extends State<T> with TickerProviderStateMixin {
  
  CustomStatefulUIState(this.animationDuration);
  final Duration animationDuration;
  late final animationController = AnimationController(
    vsync: this,
    duration: animationDuration
  );

  @override
  void dispose() {
    super.dispose();
  }
}