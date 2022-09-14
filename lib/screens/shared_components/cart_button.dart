import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/cart_screen/cart_screen.dart';
import 'package:shopping_app/viewmodels/cart_view_model.dart';

class CartButton extends StatefulWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animationOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    _animationOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -0.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceIn));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ICartViewModel>();
    viewModel.addListener(() {
      if (mounted) {
        _controller.forward();
      }
    });

    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, CartScreen.id);
      },
      icon: Stack(
        children: [
          const Icon(Icons.shopping_cart),
          Positioned(
            right: 0,
            child: SlideTransition(
              position: _animationOffset,
              child: Container(
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
                  '${viewModel.productsCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
