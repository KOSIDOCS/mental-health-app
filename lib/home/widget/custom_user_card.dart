import 'package:flutter/material.dart';

class CustomUserCard extends StatelessWidget {
  final String userImg;
  final String name;
  final String specialization;
  final int experience;
  final double minAmount;
  final double star;
  final VoidCallback? onPressed;
  const CustomUserCard({Key? key, required this.userImg, required this.name, required this.specialization, required this.experience, required this.minAmount, required this.star, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Image.asset(
            //   'assets/images/${userImg}', // replace with network image
            //   width: 96.0,
            //   height: 96.0,
            // ),
            Image.network(
              userImg, // replace with network image
              width: 96.0,
              height: 96.0,
              cacheWidth: 96,
              cacheHeight: 96,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.04,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Transform.translate(
                    offset: Offset(2, -9),
                    child: RichText(
                      text: TextSpan(
                          text: specialization,
                          style: Theme.of(context).textTheme.caption,
                          children: [
                            WidgetSpan(
                              child: Transform.translate(
                                offset: Offset(2, 1),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    '.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                          fontSize: 23.0,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: '$experience years experience',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'from $minAmount \$',
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Icon(
                      Icons.star_border_sharp,
                      size: 17.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '$star',
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '(10)',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
