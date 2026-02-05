import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pyramidion_task/core/utils/math_utils.dart';

class CircularMenuLayout extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final Widget centerWidget;
  final Animation<double> animation;
  final double itemDiameter;
  final double centerDiameter;
  final double radius;
  final double spokeWidthFactor;
  final Color spokeColor;
  final double spokeOpacity;

  const CircularMenuLayout({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.centerWidget,
    required this.animation,
    required this.itemDiameter,
    required this.centerDiameter,
    required this.radius,
    this.spokeWidthFactor = 0.30,
    this.spokeColor = const Color(0xFF6A3E9B),
    this.spokeOpacity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (itemCount == 0) {
          return const SizedBox.shrink();
        }
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        final Offset center = Offset(width / 2, height / 2);

        final double angleStep = 360 / itemCount;
        final Animation<double> spokesAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
        );

        return Stack(
          children: [
            FadeTransition(
              opacity: spokesAnimation,
              child: CustomPaint(
                size: Size(width, height),
                painter: _SpokesPainter(
                  itemCount: itemCount,
                  center: center,
                  radius: radius,
                  centerDiameter: centerDiameter,
                  itemDiameter: itemDiameter,
                  spokeWidthFactor: spokeWidthFactor,
                  color: spokeColor.withValues(alpha: spokeOpacity),
                ),
              ),
            ),
            // Center hub
            Positioned(
              left: center.dx - (centerDiameter / 2),
              top: center.dy - (centerDiameter / 2),
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
    final double start = 0.08 + (index / itemCount) * 0.08;
    final Animation<double> baseAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(
        start,
        1.0,
        curve: Curves.easeOut,
      ),
    );
    final Animation<double> radiusFactor = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.35, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 55,
      ),
    ]).animate(baseAnimation);
    final Animation<double> fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(
        start,
        0.85,
        curve: Curves.easeIn,
      ),
    );
    final Animation<double> scaleAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(
        start + 0.05,
        1.0,
        curve: Curves.easeOutBack,
      ),
    );

    return AnimatedBuilder(
      animation: radiusFactor,
      builder: (context, child) {
        final double animatedRadius = radius * radiusFactor.value;
        final double intensity = (1.0 - radiusFactor.value).clamp(0.0, 1.0);
        final Color glowBase = spokeColor;
        final List<BoxShadow> glowShadows = intensity > 0.001
            ? [
                BoxShadow(
                  color: glowBase.withValues(alpha: 0.18 * intensity),
                  blurRadius: 14 * intensity,
                  spreadRadius: 1.5 * intensity,
                ),
              ]
            : const [];
        final Offset animatedPosition = MathUtils.calculatePosition(
          radius: animatedRadius,
          angleInDegrees: angle,
          center: center,
        );
        return Positioned(
          left: animatedPosition.dx - (itemDiameter / 2),
          top: animatedPosition.dy - (itemDiameter / 2),
          child: RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: glowShadows,
              ),
              child: child!,
            ),
          ),
        );
      },
      child: FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(scale: scaleAnimation, child: itemBuilder(index)),
      ),
    );
  }
}

class _SpokesPainter extends CustomPainter {
  final int itemCount;
  final Offset center;
  final double radius;
  final double centerDiameter;
  final double itemDiameter;
  final double spokeWidthFactor;
  final Color color;

  _SpokesPainter({
    required this.itemCount,
    required this.center,
    required this.radius,
    required this.centerDiameter,
    required this.itemDiameter,
    required this.spokeWidthFactor,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (itemCount <= 0) return;
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final double angleStep = 360 / itemCount;
    final double halfSpread = angleStep * spokeWidthFactor;
    final double innerRadius = centerDiameter * 0.35;
    final double outerRadius = radius - (itemDiameter * 0.08);

    for (int i = 0; i < itemCount; i++) {
      final double angle = (-90) + (angleStep * i);
      final double start = (angle - halfSpread) * (3.141592653589793 / 180);
      final double end = (angle + halfSpread) * (3.141592653589793 / 180);

      final Offset innerStart = Offset(
        center.dx + innerRadius * math.cos(start),
        center.dy + innerRadius * math.sin(start),
      );
      final Offset innerEnd = Offset(
        center.dx + innerRadius * math.cos(end),
        center.dy + innerRadius * math.sin(end),
      );
      final Offset outerStart = Offset(
        center.dx + outerRadius * math.cos(start),
        center.dy + outerRadius * math.sin(start),
      );
      final Offset outerEnd = Offset(
        center.dx + outerRadius * math.cos(end),
        center.dy + outerRadius * math.sin(end),
      );

      final Path path = Path()
        ..moveTo(innerStart.dx, innerStart.dy)
        ..lineTo(outerStart.dx, outerStart.dy)
        ..lineTo(outerEnd.dx, outerEnd.dy)
        ..lineTo(innerEnd.dx, innerEnd.dy)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpokesPainter oldDelegate) {
    return oldDelegate.itemCount != itemCount ||
        oldDelegate.center != center ||
        oldDelegate.radius != radius ||
        oldDelegate.centerDiameter != centerDiameter ||
        oldDelegate.itemDiameter != itemDiameter ||
        oldDelegate.spokeWidthFactor != spokeWidthFactor ||
        oldDelegate.color != color;
  }
}
