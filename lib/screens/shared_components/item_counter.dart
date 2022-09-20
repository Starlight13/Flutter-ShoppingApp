import 'package:flutter/material.dart';
import 'package:shopping_app/screens/shared_components/square_button.dart';

class ItemCounter extends StatefulWidget {
  const ItemCounter({
    required this.onChange,
    this.initialCount,
    this.size = 30.0,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  final int? initialCount;
  final Function(int) onChange;
  final double size;
  final void Function()? onDelete;

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter>
    with SingleTickerProviderStateMixin {
  late int qty;
  bool isPlus = true;

  late final AnimationController _controller;

  late final Function() _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = () => Tween<Offset>(
          begin: Offset.zero,
          end: Offset(isPlus ? 0.5 : -0.5, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.elasticIn,
          ),
        );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
        setState(() {});
      }
    });

    qty = widget.initialCount ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedOpacity(
          opacity: qty == 1 && widget.onDelete == null ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: SquareButton(
            buttonSize: widget.size,
            onPressed: () {
              if (qty - 1 >= 1) {
                isPlus = false;
                _controller.forward();
                widget.onChange(--qty);
              } else if (widget.onDelete != null) {
                widget.onDelete!();
              }
            },
            buttonColor: Colors.white,
            child: const Icon(
              Icons.remove,
              color: Colors.teal,
            ),
          ),
        ),
        SlideTransition(
          position: _offsetAnimation(),
          child: SizedBox(
            width: widget.size + 10.0,
            child: Text(
              '$qty',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
        ),
        SquareButton(
          buttonSize: widget.size,
          onPressed: () {
            isPlus = true;
            _controller.forward();
            widget.onChange(++qty);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
