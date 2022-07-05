import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';

class CustomExpandItems extends StatefulWidget {
  final String title;
  final int total;
  final Widget child;
  const CustomExpandItems({Key? key, required this.title, required this.total, required this.child})
      : super(key: key);

  @override
  State<CustomExpandItems> createState() => _CustomExpandItemsState();
}

class _CustomExpandItemsState extends State<CustomExpandItems>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandBtnanimation;
  bool  _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _expandBtnanimation = Tween<double>(begin: 0.0, end: pi / 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
      ),
      margin: EdgeInsets.only(top: 26.0, bottom: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                    ),
              ),
              SizedBox(width: 8.0),
              Text(
                widget.total.toString(),
                style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                      color: AppColors.mentalBarUnselected,
                    ),
              ),
              const Spacer(),
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
                child: Text(
                  _isExpanded ? 'Show less' : 'Show all',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0,
                        color: AppColors.mentalBrandColor,
                      ),
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _expandBtnanimation.value,
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColors.mentalBrandColor,
                      size: 32.0,
                    ),
                  );
                },
              )
            ],
          ),
          _isExpanded ? widget.child : Container(),
        ],
      ),
    );
  }
}
