import 'package:flutter/material.dart';

class CircleTransitionClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  CircleTransitionClipper({
    required this.center,
    required this.radius,
  });

  @override
  getClip(Size size) {
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}