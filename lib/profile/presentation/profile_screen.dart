import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('Profile'),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}