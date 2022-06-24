import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/presentation/custom_bottom_navigation.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({Key? key}) : super(key: key);

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('Consultations'),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
