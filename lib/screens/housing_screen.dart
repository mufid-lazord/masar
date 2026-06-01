import 'package:flutter/material.dart';
import '../data/services_data.dart';
import '../utils/app_colors.dart';
import '../widgets/category_screen_template.dart';

class HousingScreen extends StatelessWidget {
  const HousingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryScreenTemplate(
      title: 'السكن',
      subtitle: 'شقق، استوديوهات، وسكن طلاب',
      icon: Icons.home_work_rounded,
      color: AppColors.housing,
      services: ServicesData.housingServices,
    );
  }
}
