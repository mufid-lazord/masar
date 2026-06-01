import 'package:flutter/material.dart';
import '../data/services_data.dart';
import '../utils/app_colors.dart';
import '../widgets/category_screen_template.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryScreenTemplate(
      title: 'التعليم',
      subtitle: 'جامعات، مدارس، ومعاهد',
      icon: Icons.school_rounded,
      color: AppColors.education,
      services: ServicesData.educationServices,
    );
  }
}
