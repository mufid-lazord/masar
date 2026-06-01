import 'package:flutter/material.dart';
import '../data/services_data.dart';
import '../utils/app_colors.dart';
import '../widgets/category_screen_template.dart';

class HealthcareScreen extends StatelessWidget {
  const HealthcareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryScreenTemplate(
      title: 'الرعاية الصحية',
      subtitle: 'مستشفيات، عيادات، وصيدليات',
      icon: Icons.medical_services_rounded,
      color: AppColors.healthcare,
      services: ServicesData.healthcareServices,
    );
  }
}
