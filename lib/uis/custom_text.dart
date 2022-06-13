import 'package:flutter/material.dart';

Text mainHeading({ required String text, required BuildContext context }) {
 return Text(
   text,
   style: Theme.of(context).textTheme.headline2!.copyWith(
     fontWeight: FontWeight.w600,
   ),
 );
}

Widget subHeadingTextLarge({ required String text, required BuildContext context }) {
 return SizedBox(
   width: MediaQuery.of(context).size.width * 0.7,
   child: Text(
     text,
     style: Theme.of(context).textTheme.headline3!.copyWith(
       fontWeight: FontWeight.w300,
       fontSize: 15.0,
     ),
   ),
 );
}