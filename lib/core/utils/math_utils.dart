import 'dart:math';
import 'package:flutter/material.dart';

class MathUtils {
  static Offset calculatePosition({
    required double radius,
    required double angleInDegrees,
    required Offset center,
  })
  {
    final double angleInRadians = angleInDegrees * (pi / 180);

    final double x = center.dx + radius * cos(angleInRadians);
    final double y = center.dy + radius * sin(angleInRadians);

    return Offset(x, y);
  }
}