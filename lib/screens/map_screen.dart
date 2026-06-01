import 'package:flutter/material.dart';
import '../data/services_data.dart';
import '../models/service_model.dart';
import '../utils/app_colors.dart';
import 'service_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedCategory = 'الكل';
  Service? _selectedService;

  List<Service> get _filteredServices {
    if (_selectedCategory == 'الكل') return ServicesData.allServices;
    return ServicesData.allServices
        .where((s) => s.category == _selectedCategory)
        .toList();
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'السكن': return AppColors.housing;
      case 'الصحة': return AppColors.healthcare;
      case 'التعليم': return AppColors.education;
      case 'السياحة': return AppColors.tourism;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // الخريطة (محاكاة بصرية)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F0E6),
                  Color(0xFFDEE8D9),
                ],
              ),
            ),
            child: CustomPaint(
              size: Size.infinite,
              painter: _MapPainter(),
            ),
          ),
          
          // دبابيس المواقع
          ...List.generate(_filteredServices.length, (index) {
            final service = _filteredServices[index];
            // توزيع الدبابيس على الشاشة
            final positions = [
              const Offset(0.2, 0.25),
              const Offset(0.7, 0.2),
              const Offset(0.3, 0.5),
              const Offset(0.8, 0.45),
              const Offset(0.5, 0.35),
              const Offset(0.15, 0.6),
              const Offset(0.75, 0.65),
              const Offset(0.45, 0.55),
              const Offset(0.25, 0.4),
              const Offset(0.65, 0.5),
              const Offset(0.55, 0.7),
              const Offset(0.35, 0.25),
              const Offset(0.6, 0.3),
              const Offset(0.2, 0.7),
              const Offset(0.7, 0.75),
              const Offset(0.4, 0.65),
            ];
            final pos = positions[index % positions.length];
            final screenSize = MediaQuery.of(context).size;
            
            return Positioned(
              left: pos.dx * screenSize.width - 25,
              top: pos.dy * screenSize.height - 40,
              child: GestureDetector(
                onTap: () => setState(() => _selectedService = service),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(_selectedService == service ? 10 : 8),
                        decoration: BoxDecoration(
                          color: service.color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: service.color.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          service.icon,
                          color: Colors.white,
                          size: _selectedService == service ? 22 : 18,
                        ),
                      ),
                      // ذيل الدبوس
                      ClipPath(
                        clipper: _TriangleClipper(),
                        child: Container(
                          width: 10,
                          height: 8,
                          color: service.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // شريط البحث
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.textSecondary),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'ابحث عن خدمات قريبة...',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // فلاتر الأقسام
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFilterChip('الكل', AppColors.primary),
                          _buildFilterChip('السكن', AppColors.housing),
                          _buildFilterChip('الصحة', AppColors.healthcare),
                          _buildFilterChip('التعليم', AppColors.education),
                          _buildFilterChip('السياحة', AppColors.tourism),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // أزرار التحكم بالخريطة
          Positioned(
            left: 16,
            bottom: _selectedService != null ? 200 : 110,
            child: Column(
              children: [
                _buildMapButton(Icons.add, () {}),
                const SizedBox(height: 8),
                _buildMapButton(Icons.remove, () {}),
                const SizedBox(height: 8),
                _buildMapButton(Icons.my_location, () {}),
              ],
            ),
          ),
          
          // بطاقة الخدمة المختارة
          if (_selectedService != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceDetailScreen(service: _selectedService!),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: _selectedService!.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _selectedService!.imageEmoji,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedService!.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 14, color: AppColors.accent),
                                const SizedBox(width: 2),
                                Text(
                                  '${_selectedService!.rating}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    _selectedService!.address,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _selectedService!.color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.directions,
                                      color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'الاتجاهات',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _selectedService = null),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, Color color) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedCategory = label;
          _selectedService = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary),
        onPressed: onTap,
      ),
    );
  }
}

// رسم خلفية الخريطة
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // شوارع
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6;
    
    // شارع أفقي رئيسي
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.35),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.65),
      Offset(size.width, size.height * 0.6),
      roadPaint,
    );
    
    // شارع عمودي
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.4, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.65, size.height),
      roadPaint,
    );
    
    // شوارع فرعية
    final smallRoadPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 3;
    
    for (double i = 0; i < size.width; i += 80) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + 20, size.height),
        smallRoadPaint,
      );
    }
    
    // مناطق خضراء (حدائق)
    final parkPaint = Paint()..color = const Color(0xFFBBD9B0);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.8),
      40,
      parkPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      30,
      parkPaint,
    );
    
    // نهر/ماء
    final waterPaint = Paint()..color = const Color(0xFFA8D0E6);
    final path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.3,
        size.width * 0.55,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.7,
        size.width * 0.5,
        size.height,
      )
      ..lineTo(size.width * 0.55, size.height)
      ..quadraticBezierTo(
        size.width * 0.65,
        size.height * 0.7,
        size.width * 0.6,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.3,
        size.width * 0.55,
        0,
      )
      ..close();
    canvas.drawPath(path, waterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
