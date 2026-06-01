import 'package:flutter/material.dart';
import '../data/services_data.dart';
import '../models/service_model.dart';
import '../utils/app_colors.dart';
import '../widgets/service_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedFilter = 'الكل';

  final List<String> _recentSearches = [
    'مستشفى في المعادي',
    'شقة مفروشة',
    'جامعة القاهرة',
    'الأهرامات',
  ];

  final List<String> _popularSearches = [
    'صيدلية 24 ساعة',
    'سكن طلاب',
    'مطعم فلسطيني',
    'مدرسة دولية',
    'معلم سياحي',
  ];

  List<Service> get _results {
    var results = ServicesData.search(_query);
    if (_selectedFilter != 'الكل') {
      results = results.where((s) => s.category == _selectedFilter).toList();
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _query.isNotEmpty;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header مع شريط البحث
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'البحث',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن خدمة، مكان، أو منطقة...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: hasQuery
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                      fillColor: AppColors.background,
                    ),
                  ),
                  if (hasQuery) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildCategoryFilter('الكل', AppColors.primary),
                          _buildCategoryFilter('السكن', AppColors.housing),
                          _buildCategoryFilter('الصحة', AppColors.healthcare),
                          _buildCategoryFilter('التعليم', AppColors.education),
                          _buildCategoryFilter('السياحة', AppColors.tourism),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // النتائج أو الاقتراحات
            Expanded(
              child: hasQuery ? _buildResults() : _buildSuggestions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(String label, Color color) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? color : AppColors.divider),
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

  Widget _buildResults() {
    final results = _results;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.textLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 60,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'لا توجد نتائج',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'جرب كلمات بحث مختلفة',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'تم العثور على ${results.length} نتيجة',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        ...results.map((service) => ServiceCard(service: service)),
      ],
    );
  }

  Widget _buildSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // عمليات البحث الأخيرة
        Row(
          children: [
            const Icon(Icons.history, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            const Text(
              'بحث سابق',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                'مسح',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._recentSearches.map((search) => _buildRecentItem(search)),
        
        const SizedBox(height: 24),
        
        // الأكثر بحثاً
        const Row(
          children: [
            Icon(Icons.trending_up, color: AppColors.tourism, size: 20),
            SizedBox(width: 8),
            Text(
              'الأكثر بحثاً',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _popularSearches.map((search) {
            return GestureDetector(
              onTap: () {
                _searchController.text = search;
                setState(() => _query = search);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      search,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 24),
        
        // تصفح حسب الفئة
        const Text(
          'تصفح حسب الفئة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: [
            _buildCategoryQuickCard('السكن', Icons.home_work, AppColors.housing),
            _buildCategoryQuickCard('الصحة', Icons.medical_services, AppColors.healthcare),
            _buildCategoryQuickCard('التعليم', Icons.school, AppColors.education),
            _buildCategoryQuickCard('السياحة', Icons.place, AppColors.tourism),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentItem(String text) {
    return GestureDetector(
      onTap: () {
        _searchController.text = text;
        setState(() => _query = text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.history, color: AppColors.textLight, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.north_west,
                color: AppColors.textLight, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryQuickCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
          _query = title;
          _searchController.text = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
