import 'package:flutter/material.dart';
import 'package:pyramidion_task/core/constants/app_colors.dart';
import 'package:pyramidion_task/data/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  const CategoryItem({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * .18;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_imageBubble(context), const SizedBox(height: 6), _label(size + 8)],
      ),
    );
  }

  Widget _imageBubble(BuildContext context) {
     final size = MediaQuery.of(context).size.width * .18;
    return Container(
       width: size,
       height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        category.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return const Icon(Icons.image_not_supported);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      ),
    );
  }

  Widget _label(double width) {
  return SizedBox(
    width: width,
    child: Text(
      category.name,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 13,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
}
