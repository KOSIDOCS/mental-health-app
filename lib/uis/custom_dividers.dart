import 'package:flutter/material.dart';

class CustomShortDividers extends StatelessWidget {
  const CustomShortDividers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
      ),
      child: Divider(
        color: Theme.of(context).dividerColor,
        thickness: 1.0,
      ),
    );
  }
}
