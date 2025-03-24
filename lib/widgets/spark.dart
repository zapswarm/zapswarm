import 'dart:math';
import 'package:flutter/material.dart';

class Spark {
  final Color color;
  double x, y, dx, dy;

  Spark({required this.color})
      : x = Random().nextDouble() * 400,
        y = Random().nextDouble() * 800,
        dx = (Random().nextDouble() - 0.5) * 4,
        dy = (Random().nextDouble() - 0.5) * 4;

  Widget build(BuildContext context, bool isPulsing) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      left: x,
      top: y,
      onEnd: () {},
      child: Container(
        width: isPulsing ? 18 : 12,
        height: isPulsing ? 18 : 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 12)],
        ),
      ),
    );
  }
}