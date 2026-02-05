import 'package:flutter/material.dart';
import 'package:pyramidion_task/core/utils/math_utils.dart';

class CircularMenuLayout extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final Widget centerWidget;
  final Animation<double> animation;

  const CircularMenuLayout({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.centerWidget,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        final double radius = constraints.maxHeight * 0.2;

        final Offset center = Offset(width / 2, height / 2);

        final double angleStep = 360 / itemCount;

        return Stack(
          children: [
            // Center hub
            Positioned(
              left: center.dx - 60,
              top: center.dy - 60,
              child: centerWidget,
            ),

            for (int i = 0; i < itemCount; i++)
              _buildPositionedItem(i, angleStep, radius, center),
          ],
        );
      },
    );
  }

  Widget _buildPositionedItem(
    int index,
    double angleStep,
    double radius,
    Offset center,
  ) {
    final double angle = (-90) + (angleStep * index);
    final Offset position = MathUtils.calculatePosition(
      radius: radius,
      angleInDegrees: angle,
      center: center,
    );
    final Animation<double> itemAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(
        0.3 + (index / itemCount) * 0.5,
        1.0,
        curve: Curves.easeOutBack,
      ),
    );

    return Positioned(
      left: position.dx - 36,
      top: position.dy - 36,
      child: FadeTransition(
        opacity: itemAnimation,
        child: ScaleTransition(scale: itemAnimation, child: itemBuilder(index)),
      ),
    );
  }
}
