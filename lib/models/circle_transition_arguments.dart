import 'package:flutter/material.dart';
import 'package:shopping_app/models/product.dart';

class CircleTransitionArguments {
  final Product product;
  final Offset circleStartCenter;

  CircleTransitionArguments({
    required this.product,
    required this.circleStartCenter,
  });
}
