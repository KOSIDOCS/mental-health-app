import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';

class MainHomeDetailsScreen extends StatefulWidget {
  const MainHomeDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeDetailsScreen> createState() => _MainHomeDetailsScreenState();
}

class _MainHomeDetailsScreenState extends State<MainHomeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.chevron_left,
                            color: Theme.of(context).iconTheme.color,
                            size: 32.0,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, right: 17.0),
                          child: Icon(
                            Icons.bookmark_outline_rounded,
                            color: Theme.of(context).iconTheme.color,
                            size: 32.0,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 22.0),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
                            height: 110.0,
                            width: 110.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            'Drozdov Pavel',
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
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
                                  text: 'Gestalt',
                                  style: Theme.of(context).textTheme.caption,
                                  children: [
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: Offset(2, 1),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
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
                                      text: '4 years experience',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getStars(4, 4.0),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '4.8',
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
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                height: 90.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
                child: Text('Heelo'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getStars(int count, double rate) {
    List<Widget> stars = [];
    for (int i = 0; i < count; i++) {
      stars.add(Icon(
        Icons.star,
        size: 20.0,
        color: AppColors.mentalStarColor,
      ));
    }
    return Row(
      children: stars
        ..add(Icon(
          Icons.star_border,
          size: 20.0,
          color: AppColors.mentalStarColor,
        )),
    );
  }
}
