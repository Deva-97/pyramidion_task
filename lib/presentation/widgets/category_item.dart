import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pyramidion_task/core/constants/app_colors.dart';
import 'package:pyramidion_task/data/models/category_model.dart';

class CategoryItem extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final double diameter;
  final bool isSelected;
  const CategoryItem({
    super.key,
    required this.category,
    required this.onTap,
    required this.diameter,
    required this.isSelected,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double scale =
        _isPressed ? 0.97 : (widget.isSelected ? 1.03 : 1.0);

    return Semantics(
      label: '${widget.category.name} category',
      button: true,
      onTapHint: 'Select ${widget.category.name}',
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: widget.diameter,
          height: widget.diameter,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFF7A53D2)
                  : Colors.transparent,
              width: widget.isSelected ? 2.5 : 0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: AppColors.white,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkResponse(
              onTap: widget.onTap,
              onTapDown: (_) => _setPressed(true),
              onTapCancel: () => _setPressed(false),
              onTapUp: (_) => _setPressed(false),
              containedInkWell: true,
              highlightShape: BoxShape.circle,
              splashColor: const Color(0xFF7A53D2).withValues(alpha: 0.15),
              child: _bubbleContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bubbleContent() {
    final bool hasImage = widget.category.imageUrl.trim().isNotEmpty;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: widget.diameter * 0.12,
          child: SizedBox(
            width: widget.diameter * 0.52,
            height: widget.diameter * 0.52,
            child: hasImage
                ? CachedNetworkImage(
                    imageUrl: widget.category.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, _) => Center(
                      child: SizedBox(
                        width: widget.diameter * 0.18,
                        height: widget.diameter * 0.18,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.spokeColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, _, _) {
                      return const Icon(Icons.image_not_supported);
                    },
                  )
                : const Icon(Icons.image_not_supported),
          ),
        ),
        Positioned(
          bottom: widget.diameter * 0.12,
          left: widget.diameter * 0.08,
          right: widget.diameter * 0.08,
          child: Text(
            widget.category.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: widget.diameter * 0.17,
              color: AppColors.labelText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
