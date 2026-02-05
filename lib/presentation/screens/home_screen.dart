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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Shop by Categories',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

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
    switch(provider.status){
      case CategoryStatus.loading:
      return const Center(
        child: CircularProgressIndicator(color: AppColors.white,),
      );
      case CategoryStatus.error:
      return Center(
        child: Text(
          provider.errorMessage,
          style: TextStyle(color: AppColors.white),
        ),
      );
    case CategoryStatus.success:
  return LayoutBuilder(
    builder: (context, constraints) {
      return CircularMenuLayout(
        animation: _controller,
        itemCount: provider.categories.length,
        centerWidget: _animatedCenterHub(),
        itemBuilder: (index) {
          final category = provider.categories[index];
          return CategoryItem(
            category: category,
            onTap: () {
              debugPrint(category.name);
            },
          );
        },
      );
    },
  );



      default:
      return const SizedBox.shrink();
    }
  }

  Widget _animatedCenterHub() {
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
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Text(
          'HOME',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}

}