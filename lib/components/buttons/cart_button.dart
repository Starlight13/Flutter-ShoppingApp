import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/models/cart/cart.dart';

class CartButton extends StatelessWidget {
  CartButton({
    Key? key,
    this.controller,
  }) : super(key: key) {
    if (controller != null) {
      _animationOffset = Tween<Offset>(
        begin: const Offset(0.0, 0.0),
        end: const Offset(0.0, -0.5),
      ).animate(CurvedAnimation(parent: controller!, curve: Curves.bounceIn));
    }
  }

  final AnimationController? controller;

  late final Animation<Offset>? _animationOffset;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, CartScreen.id);
      },
      icon: Stack(
        children: [
          const Icon(Icons.shopping_cart),
          Positioned(
            right: 0,
            child: getItemCounter(context),
          ),
        ],
      ),
    );
  }

  Widget getItemCounter(BuildContext context) {
    final Widget countIdicator = Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(6),
      ),
      constraints: const BoxConstraints(
        minWidth: 12,
        minHeight: 12,
      ),
      child: Text(
        '${context.watch<Cart>().productsCount}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
        ),
        textAlign: TextAlign.center,
      ),
    );

    if (controller == null) {
      return countIdicator;
    } else {
      return SlideTransition(
        position: _animationOffset!,
        child: countIdicator,
      );
    }
  }
}
