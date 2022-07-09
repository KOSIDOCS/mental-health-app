import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(child: Text('Chat home'),),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
