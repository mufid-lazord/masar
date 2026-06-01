import 'package:flutter/material.dart';
import '../data/services_data.dart';
import '../utils/app_colors.dart';
import '../widgets/category_screen_template.dart';

class TourismScreen extends StatelessWidget {
  const TourismScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryScreenTemplate(
      title: 'السياحة',
      subtitle: 'معالم أثرية وأماكن سياحية',
      icon: Icons.place_rounded,
      color: AppColors.tourism,
      services: ServicesData.tourismServices,
    );
  }
}
