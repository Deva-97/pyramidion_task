import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyramidion_task/core/constants/app_colors.dart';
import 'package:pyramidion_task/logic/category_provider.dart';
import '../widgets/circular_menu_layout.dart';
import '../widgets/category_item.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? _selectedCategoryId;
  bool _hasAnimatedOnData = false;
  int _lastCategoryCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color titleColor = isDark ? AppColors.white : AppColors.textDark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.backgroundGradientDark
              : AppColors.backgroundGradientLight,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Shop by Categories',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: _buildCenterContent(provider),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildCenterContent(CategoryProvider provider){
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bodyTextColor = isDark ? AppColors.white : AppColors.textDark;
    if (provider.status == CategoryStatus.loading) {
      _hasAnimatedOnData = false;
    }
    switch(provider.status){
      case CategoryStatus.loading:
      return Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.white : AppColors.spokeColor,
        ),
      );
      case CategoryStatus.error:
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.errorMessage,
              style: TextStyle(color: bodyTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => provider.fetchCategories(),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    isDark ? AppColors.white : AppColors.spokeColor,
                side: BorderSide(
                  color: isDark ? AppColors.white : AppColors.spokeColor,
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    case CategoryStatus.success:
  if (provider.categories.isEmpty) {
    return Center(
      child: Text(
        'No categories available',
        style: TextStyle(color: bodyTextColor),
      ),
    );
  }
  _startEntranceAnimation(provider.categories.length);
  return LayoutBuilder(
    builder: (context, constraints) {
      final double menuSize =
          math.min(constraints.maxWidth, constraints.maxHeight);
      final double scale = menuSize < 360
          ? 1.05
          : menuSize < 400
              ? 1.15
              : 1.25;
      final double itemDiameter = menuSize * 0.18 * scale;
      final double centerDiameter = menuSize * 0.20 * scale;
      final double radius = menuSize * 0.30 * scale;

      return Stack(
        alignment: Alignment.center,
        children: [
          Center(
        child: SizedBox(
          width: menuSize,
          height: menuSize,
          child: CircularMenuLayout(
            animation: _controller,
            itemCount: provider.categories.length,
            centerWidget: _animatedCenterHub(centerDiameter),
            itemDiameter: itemDiameter,
            centerDiameter: centerDiameter,
            radius: radius,
            spokeColor: AppColors.spokeColor,
            itemBuilder: (index) {
              final category = provider.categories[index];
              return CategoryItem(
                category: category,
                diameter: itemDiameter,
                isSelected: category.id == _selectedCategoryId,
                onTap: () {
                  setState(() {
                    _selectedCategoryId = _selectedCategoryId == category.id
                        ? null
                        : category.id;
                  });
                  debugPrint(category.name);
                },
              );
            },
          ),
        ),
          ),
          if (provider.usedCache)
            Positioned(
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.black : Colors.black)
                      .withValues(alpha: isDark ? 0.35 : 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'No internet — showing cached data',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      );
    },
  );



      default:
      return const SizedBox.shrink();
    }
  }

  void _startEntranceAnimation(int count) {
    if (_hasAnimatedOnData && _lastCategoryCount == count) return;
    _hasAnimatedOnData = true;
    _lastCategoryCount = count;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.forward(from: 0.0);
    });
  }

  Widget _animatedCenterHub(double centerDiameter) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ),
    child: ScaleTransition(
      scale: CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
      child: Semantics(
        label: 'Home hub',
        child: Container(
          width: centerDiameter,
          height: centerDiameter,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [
                Color(0xFF7A53D2),
                Color(0xFF4E2A8A),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.home,
            color: Colors.white,
            size: centerDiameter * 0.45,
          ),
        ),
      ),
    ),
  );
}

}
