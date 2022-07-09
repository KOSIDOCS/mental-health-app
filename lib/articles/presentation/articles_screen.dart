import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('Articles'),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}