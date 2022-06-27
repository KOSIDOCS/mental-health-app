import 'package:flutter/material.dart';

abstract class CustomStatefulUIState<T extends StatefulWidget> extends State<T> with TickerProviderStateMixin {
  
  CustomStatefulUIState(this.animationDuration);
  final Duration animationDuration;
  late final animationController;
  late Animation mainHeadingAnimation;
  late Animation searchIconAnimation;
  late Animation buttontabsAnimation;
  late Animation bodyAnimation;

  @override
  void initState() {
    super.initState();

    // initialise the animation controller
    animationController = AnimationController(
    vsync: this,
    duration: animationDuration
  );

  // main heading animation
  mainHeadingAnimation = Tween(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.0,
        0.30,
        curve: Curves.easeInOut,
      ),
    ),
  );

  searchIconAnimation = Tween(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Interval(0.30, 0.50, curve: Curves.easeOut),
    ),

  );

  buttontabsAnimation = Tween(begin: -80.0, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.50,
        0.80,
        curve: Curves.easeInOut,
      ),
    ),

  );

  bodyAnimation = Tween(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.80,
        1.0,
        curve: Curves.easeInOut,
      ),
    ),
  );

  }

  @override
  void dispose() {
    super.dispose();
  }
}